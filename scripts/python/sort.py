#! /bin/python
import bibtexparser
from bibtexparser.bparser import BibTexParser
import re
import os
import shutil
import math

script_dir = os.path.dirname(os.path.abspath(__file__))
database_file = '../literature/literature.bib'
backup_file = '../literature/literature.backup.bib'
output_file = '../literature/literature.bib'
comment_pattern = re.compile(r'^%+\s*([a-zA-Z\s]+)\s+%+$', re.M)
special_char_pattern = re.compile(r'[^a-zA-Z0-9]')
line_ending_pattern = re.compile(r'\s*[\n\r]+\s*')

field_order = ['renamedfrom',
                'subsumedby',
                'subsumes',
                'comments',
                'missing',
                'author',
                'title',
                'subtitle',
                'titleaddon',
                'journal',
                'booktitle',
                'series',
                'type',
                'editor',
                'edition',
                'version',
                'volume',
                'number',
                'chapter',
                'pages',
                'location',
                'organization',
                'school',
                'institution',
                'holder',
                'language',
                'addendum',
                'note',
                'url',
                'doi',
                'howpublished',
                'publisher',
                'address',
                'month',
                'year',
                'date',]

months = {
    "none": "0",
    "jan": "1",
    "feb": "2",
    "mar": "3",
    "apr": "4",
    "may": "5",
    "jun": "6",
    "jul": "7",
    "aug": "8",
    "sep": "9",
    "oct": "10",
    "nov": "11",
    "dec": "12"
}

def print_field(entry, field):
    value = entry[field]
    fieldName = special_char_pattern.sub('', field)
    if field == 'year':
        value = line_ending_pattern.sub(' ', value)
        s = '\t{0:9s} = {1},\n'.format(fieldName, value)
    elif isinstance(value, str):
        value = line_ending_pattern.sub(' ', value)
        s = '\t{0:9s} = {{{1}}},\n'.format(fieldName, value)
    else:
        s = '\t{0:9s} = '.format(fieldName)
        for expr_part in value.expr:
            if isinstance(expr_part, str):
                expr_part_value = '{{{0}}}'.format(line_ending_pattern.sub(' ', expr_part))
            else:
                expr_part_value = line_ending_pattern.sub(' ', expr_part.name)
            s += expr_part_value + ' # '
        s = s[:len(s)-3] + ',\n'
    return s


def get_field_text(entry, field, default):
    if not field in entry:
        return default

    value = entry[field]
    if isinstance(value, str):
        return value
    else:
        return value.expr[0].name


def sort_key(entry):
    return (-int(entry.get('year', '0')),
            entry.get('ENTRYTYPE', ''),
            -int(months[get_field_text(entry, 'month', 'none')]),
            get_field_text(entry, 'booktitle', '').lower(),
            get_field_text(entry, 'journal', '').lower(),
            entry.get('ID', '').lower())


def sort_key_year(year):
    return -int(year)

def sort_key_natural(field_name):
    return [(int(c) if c.isdigit() else c) for c in re.split(r'(\d+)', field_name)]

def create_parser():
    parser = BibTexParser(common_strings=False,interpolate_strings=False)
    parser.homogenise_fields=True
    parser.ignore_nonstandard_types=False
    return parser


def format_comment(text):
    padding_count = (80 - (len(text)+2)) / 2
    padding_left = "%" * math.floor(padding_count)
    padding_right = "%" * math.ceil(padding_count)
    return padding_left + " " + text + " " + padding_right + "\n\n"


def print_entries_of_year(f, cur_year_entries):
    cur_year_entries = sorted(cur_year_entries, key=sort_key)
    for entry in cur_year_entries:
        s = '@{0}{{{1},\n'.format(entry['ENTRYTYPE'], entry['ID'])
        for field in field_order:
            if field in entry:
                s += print_field(entry, field)
        extra_fields = sorted([field for field in entry if not field in field_order and not field in ['ENTRYTYPE', 'ID']], key=sort_key_natural)
        for field in extra_fields:
            s += print_field(entry, field)
        s += '}\n\n'
        f.write(s)


if __name__ == '__main__':
    if not os.path.exists(database_file):
        print("Literature file "+ database_file + " not found!")
        exit()

    if os.path.exists(backup_file):
        os.remove(backup_file)
    shutil.copyfile(database_file, backup_file)

    if os.path.exists(output_file):
        os.remove(output_file)

    with open(backup_file) as bibtex_file:
        print("Reading literature file "+ database_file + "...")
        bibtex_text = bibtex_file.read()
        bibtex_segments = re.split(comment_pattern, bibtex_text)
        bibtex_segments.pop(0)

        with open(output_file, 'a') as f:
            entries = []
            print("Writing strings...")
            for i in range(0, len(bibtex_segments), 2):
                comment = bibtex_segments[i]
                segment = bibtex_segments[i+1]

                bib_database = bibtexparser.loads(segment, create_parser())
                strings = bib_database.strings
                entries.extend(bib_database.get_entry_list())
                if len(strings) > 0:
                    if comment is not None:
                        f.write(format_comment(comment))

                    for key, value in strings.items():
                        f.write('@String{' + key + ' = "' + value + '"}\n')

                    f.write('\n')

            print("Writing entries...")
            if len(entries) > 0:
                entries_by_year = {}
                unpublished_entries = []
                for entry in entries:
                    if 'note' in entry and 'toappear' in print_field(entry, 'note'):
                        unpublished_entries.append(entry)
                    else:
                        year = str(entry.get('year', '0'))
                        if year not in entries_by_year:
                            entries_by_year[year] = []
                        entries_by_year[year].append(entry)

                if len(unpublished_entries) > 0:
                    f.write(format_comment('Unpublished Entries'))
                    print_entries_of_year(f, unpublished_entries)

                years = sorted(list(entries_by_year.keys()), key=sort_key_year)
                for year in years:
                    f.write(format_comment(year))
                    print_entries_of_year(f, entries_by_year[year])

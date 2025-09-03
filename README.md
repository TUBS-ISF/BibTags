# BibTags

This is BibTags, a BibTeX library that contains many curated literature references to papers in computer science, with a focus on variability and software product lines.

## How To Use
1. Clone this repo (e.g., `git clone https://github.com/TUBS-ISF/BibTags.git`) or add as a submodule (e.g., `git submodule add https://github.com/TUBS-ISF/BibTags.git`)
2. Run `./run clean`
3. Use `MYshort.bib` and `literature-cleaned.bib` as bibliography files in your LaTeX document

## How to Edit
1. Clone this repo
2. Create a branch
3. Modify `literature.bib` and if necessary `MYshort.bib` and `MYabrv.bib`. __Pay attention to the policies and hints below!__
4. Run `./run sort`. __Pay attention to the console output! On error go to 3.__
5. Run `./run test`. __Pay attention to the console output! On error or warning go to 3.__
6. Commit and push your changes
7. Make a pull request to the original repo, which will be reviewed by an ISF member

*Life hack: Enable a pre-commit hook to enforce steps 4 and 5 (see below).*

## Sorting Order
Entries and their fields are sorted by the `sort` script.
- Entries are sorted by 
  - publication status (unpublished or published, determined by the `toappear` note)
  - year
  - type (e.g. `article`, `inproceedings`)
  - month
  - journal or conference name
  - BibTeX key
- Fields are sorted depending on the type of entry.
  For each entry there is a configurable order of fields (e.g. author, title, booktitle, ...).
  All fields that are not part of this order are appended in alphabetical order.
- Strings are not sorted.
  - Universities are currently (manually) sorted by city name
  - Locations are currently (manually) sorted by country and city name

## Policies
- **Maintain consistent order of attributes** of entries. If you want to add a new entry, a good strategy is to copy an existing entry of the same type and adapt it.
- **Keys are formatted** using author names, publication venue, and year of publication: `<author abbreviation>:<venue><year>`. For example a paper published at `ICSE` in `2005` by `Alice Change` and `Bob Delta` would have the key `CD:ICSE05`. In the following each key element is explained:
  - `<author abbreviation>`:
    - If the entry is a thesis: `<author abbreviation>` = `<last name of author>`. In case of a key conflict use `<author abbreviation>` = `<last name of author><first name of author>`
    - If entry has <=4 authors: `<author abbreviation>` = `<first letter of last name of author 1><first letter of last name of author 2>...`
    - If the entry has >4 authors: `<author abbreviation>` = `<first letter of last name of author 1><first letter of last name of author 2><first letter of last name of author 3>+`
  - `<venue>`: Each venue has an abbreviation (e.g., `ICSE`, `SoSym`, `ESECFSE`). These abbreviations are defined in `MYabrv.bib` and `MYshort.bib`. If a venue you encounter is not contained in these files, please add it (sorted in ascending alphabetic order). Use this abbreviation as the `<venue>` value.
  - `<year>`: Short version of the year the entry was published in. It has only two digits, ommitting the first two digits of a year number (i.e., `96` for 1996 and `05` for 2005). If you get old enough to find a redundancy caused by this two-digit abbreviation: congratulations.
  - In case that the generated key is conflicting with an existing key, add a suffix, such as `b`, `c`, ...
- **If a journal does not have an official abbreviation** of letters only we still use our custom abbreviation for MYshort.bib. For example, the _Journal on Software Maintenance: Research and Practice_ should be abbreviated _J. Softw. Maint: Res. Pract._ but not by its variable name `JSMRP` we invented. Still, we abbreviate it in MYshort with `@String{JSMRP = "JSMRP"}` for consistency.
- **If you detect an ill-formed key**, please update it. Add a corresponding `renamedFrom = {...},` containing the previous key, such that authors of papers using the old key can quickly find the updated key:
    ```tex
    @inproceedings{KAK:ICSE08,
        renamedFrom = {KAK08},
    	author = {Christian K\"{a}stner and Sven Apel and Martin Kuhlemann},
    	title = {{Granularity in Software Product Lines}},
    	booktitle = ICSE,
    	...
    }
    ```
- **Month and Year**: 
  - **Journal Articles**: The publication month and year of a journal is that when the issue (not the article) is published. DBLP seems to have solid knowledge on that (compared to Springer's own website).
  - **For theses**, we always use the month when the thesis was defended (not when it is submitted and not when it is finally published, which might happen much later).
  - **For conferences**, we use the month and year of the conference event. When a conference happens to be held on the boundary between two months, we use the month of the first conference day.
- When adding **unpublished articles**, try to already add the DOI. Helps to keep track of the publication status.

### Policies for Theses
- **Keys** of theses are formatted according to the formatting rules described above.
- **The month of a thesis entry** is the month of the defense (because publication of a thesis might happen much later).
- **Publication status of theses** should be indicated in exactly one of the following three ways:
  - If the thesis is already published, add DOI and URL. The URL should directly point to the PDF.
  - If the thesis is not published and should not be published, add `comments = nottobepublished,`.
  - If the thesis is not published but should be published, add `note = toappear`.
- **Add `type` for bachelor, master, and project thesis**. These theses should be specified as `@mastersthesis` as it is the only bibtex entry type for thesis (apart from `@phdthesis`). Distinguish between different types of theses by using `type = Bachelor`, `type = Master`, or `type = Project` respectively.
- **For theses written in german** add `note = {In German}`.

## Policies for Updating Existing Entries
- When a paper happens to become **subsumed**, please change the key.
  This way, we make sure to update all references of outdated publications.
  In addition, you may want to use the `subsumedby` field.

## Tips and Tricks
- When checking whether all your papers are **complete**, it is helpful to compare all papers on your website (or in Bibtags) with those being listed in ACM, DBLP and Google Scholar.
  ACM and DBLP do have the best quality in their data.

## Custom Fields
Use custom fileds to add additional information for single entries. **Do not write comments in between entries.**
- **comments**: Contains miscellaneous comments for this entry.
  - Common strings:
    - nottobepublished (For Bachelor/Master theses)
  - Example: `comments = nottobepublished,`

- **missing**: Documents which information for required fields are unavailable for this entry.
  `#` can be used to concatenate several strings 
  - Common strings:
    - nodoi
    - nourl
    - nopages
    - nomonth
    - nopublisher
    - noaddress
    - nochapterno
  - Example: `missing = nodoi # nourl # nomonth # noaddress,`

- **subsumes**: Contains all keys of entries that are subsumed by this entry.
  - Example: `subsumes = {RBP+:TR22,RPTS:FORTE22,RPTS:TR22},`

- **subsumedby**: Contains the key of the entry that subsumes this entry.
  - Example: `subsumedBy = {RBP+:LMCS23},`

- **renamedFrom**: Contains previous keys of this entry.
  - Example: `renamedFrom = {AGK+:SPLC2020},`

## DON'Ts
- **Edit `literature-cleaned.bib`**: This is a generated file. It is generated from literature cleaned with [MibTeX](https://github.com/SoftVarE-Group/MibTeX). After you changed `literature.bib`, you can update `literature-cleaned.bib` by running `clean.sh` / `clean.bat`.
- Commit changes **without running `./run sort` first**.

## Testing
Many problems with added (and some existing) entries can be detected automatically by running `./run test`.
This does multiple checks:
1. Creates literature-cleaned.bib using mibtex
2. Compiles bib files with latex
  1. Using biblatex and biber to compile `literature.bib` and `MYshort.bib`
  2. Using biblatex and biber to compile `literature.bib` and `MYabrv.bib`
  3. Using natbib and bibtex to compile `literature.bib` and `MYshort.bib`
  4. Using natbib and bibtex to compile `literature-cleaned.bib` and `MYshort.bib`
3. Runs python script `scripts/python/check_integrity.py`

The script display problems in the console output. However, the complete output of all called tools can be found in individual .log files in the directory `test`. This directory also contains the compiled pdf files, for further manual inspection.

### check_integrity.py
This script performs multiple checks for all entries in the file `literature.bib`.
1. Tests that fields declared as string fields contain only string values.
2. Creates bibtex strings for fields that are declared as string fields but do not contains string values and prints them to the console.
3. Tests that for each entry *required*, *wanted* and *optional* exist or are declared as missing.
4. Tests that the title of each entry is protected (uses `{{...}}`).
5. Tests that the title of each entry is correctly capitalized (this may produce false optional results for some titles).
6. Tests that the pages of each entry are formated correctly (use `--`).
7. Tests that the names of authors of each entry follow the syntax `<last name>, <first name> and ...`.
8. Tests that the key of each entry conforms to our naming scheme (may also produce false positive results).

All detected problems are written to the console grouped by entries.

The script can be configured using the following files 
- `scripts/test/config_check_integrity.yaml`: Declares which specific checks are enabled/disabled.
- `scripts/test/config_field_types.yaml`: Declares for each entry type (e.g. inproceedings, article, ...) which fields are required (must be present), wanted (additional useful information), or optional (can be present, but are mostly ignored). Some fields are mutually exclusive, such as volume and number for inproceedings entries. This is defined by using sub lists in the config file.
      For example: ```
      - - volume
        - number
      ```
- `scripts/test/config_string.yaml`: Declares which fields should contain bibtex strings instead of literals.

### Good practice: Check locally

To detect typical problems, running `./run sort` and `./run test` are crucial.
By default, you have to manually remember to do this, which is easy to forget.
You can optionally enable a pre-commit hook that always performs certain checks locally before allowing a commit.
There are several options:

- Check for sorting + test literature (this effectively executes the CI pipeline locally):
  ```
  echo '#!/usr/bin/env sh
  set -e
  ./run sorted
  ./run test' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  ```
- Check for sorting only (this runs much faster than the previous option, but won't catch all mistakes):
  ```
  echo '#!/usr/bin/env sh
  set -e
  ./run sorted' > .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  ```
- To completely disable local checking again (the default state):
  ```
  rm -f .git/hooks/pre-commit
  ```
- To skip checking only on a single commit, run:
  ```
  git commit --no-verify
  ```

## Troubleshooting

- If you encounter the error message `short-natbib bibtex (Run 1/2)...fail` without any further error messages, try to clear the biber cache:
  ```
  biber --cache # check path first
  rm -rf "$(biber --cache)" # then remove
  ```
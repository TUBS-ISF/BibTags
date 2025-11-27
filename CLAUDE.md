# Claude Guide: Formatting BibTeX Entries

This document provides a step-by-step workflow for Claude to format existing BibTeX entries according to the repository's policies and conventions.

---

## Quick Reference Checklist

When formatting an entry, check ALL of the following:

- [ ] **Key format**: `<author abbrev>:<venue><year>`
- [ ] **Author names**: `LastName, FirstName and ...`
- [ ] **Title**: Protected with double braces `{{...}}` and title case
- [ ] **Booktitle/Journal**: Uses BibTeX string from MYabrv.bib/MYshort.bib
- [ ] **Pages**: Uses `--` (not `-` or `–`)
- [ ] **Year**: 4-digit year
- [ ] **Month**: Appropriate month value if available
- [ ] **URL**: Direct link to PDF if possible
- [ ] **DOI**: Added if available
- [ ] **Missing field**: Document any unavailable required/wanted fields
- [ ] **Field order**: Matches standard order for entry type

---

## Step-by-Step Formatting Workflow

### Step 1: Fix the Entry Key

**Format**: `<author abbrev>:<venue><year>`

#### Author Abbreviation Rules:
- **Thesis**: Last name only (e.g., `Smith` or `SmithJ` if conflict)
- **1 author (non-thesis)**: First letter of author's last name (e.g., `S` for Semenov)
- **2-4 authors**: First letter of each author's last name (e.g., `CD` for Change & Delta)
- **>4 authors**: First 3 letters + `+` (e.g., `ABC+`)

#### Venue Abbreviation:
- Use the key from `MYabrv.bib` / `MYshort.bib`
- If not present AND the venue is used multiple times, add it to BOTH files (see Section on Adding Venues)
- If venue is only used once, you can still use a custom abbreviation in the key (e.g., `PDM` for Prikladnaya Diskretnaya Matematika) without adding to abbreviation files

#### Year:
- Last 2 digits only (e.g., `05` for 2005, `23` for 2023)

#### Handle Conflicts:
- If key exists, add suffix `b`, `c`, etc.
- If updating an old key, add `renamedFrom = {old-key},` field

**Examples:**
```bibtex
% Bad key for 3-author paper
@inproceedings{MdBS+:08,

% Good key (3 authors: Meert, Vlasselaer, Van den Broeck = MVV)
@inproceedings{MVV:StarAI16,

% Good key for single-author article (Semenov = S, not Sem)
@article{S:PDM09,
```

---

### Step 2: Fix Author Names

**Format**: `LastName, FirstName and LastName, FirstName and ...`

#### Rules:
- ALWAYS use comma to separate last name from first name
- Use `and` (not commas) to separate different authors
- Remove any institutional affiliations
- Pay attention to multi-part last names (e.g., "Van den Broeck")

**Example:**
```bibtex
% Bad
author = {Wannes Meert and Jonas Vlasselaer Guy Van den Broeck and Computer Science},

% Good
author = {Meert, Wannes and Vlasselaer, Jonas and Van den Broeck, Guy},
```

---

### Step 3: Fix Title

**Format**: `{{Title With Proper Capitalization}}`

#### Rules:
- MUST be protected with double braces `{{...}}`
- Use title case (capitalize first word and important words)
- Keep acronyms capitalized

**Example:**
```bibtex
% Bad
title = {A Relaxed Tseitin Transformation for Weighted Model Counting},

% Good
title = {{A Relaxed Tseitin Transformation for Weighted Model Counting}},
```

---

### Step 4: Fix Booktitle/Journal Field

**Use BibTeX strings instead of literal text**

#### For Conferences/Workshops:
```bibtex
% Bad
booktitle = {Proceedings of the Sixth International Workshop on Statistical Relational AI (StarAI)},

% Good
booktitle = StarAI,
```

#### For Journals:
```bibtex
% Bad
journal = {IEEE Transactions on Software Engineering},

% Good
journal = TSE,
```

#### If venue not in MYabrv.bib/MYshort.bib:
You MUST add it to both files first (see "Adding Venue Abbreviations" section below)

---

### Step 5: Fix Pages

**Format**: Use `--` (double dash), not `-` or `–`

**Example:**
```bibtex
% Bad
pages = {1-7},

% Good
pages = {1--7},
```

---

### Step 6: Fix Year and Month

#### Year:
- Must be 4-digit format: `2016` not `16`
- For conferences: Use year of conference event
- For journals: Use year issue was published
- For theses: Use year of defense

#### Month:
- For conferences: Use month of first conference day
- For journals: Use month issue was published
- For theses: Use month of defense
- Use lowercase: `jan`, `feb`, `mar`, etc.
- If unavailable, add to `missing` field: `missing = nomonth,`

**Example:**
```bibtex
% If the workshop was in 2016 (check actual date)
year = 2016,
month = jul,
```

---

### Step 7: Check URL and DOI

#### URL:
- Should point directly to PDF if possible
- Format varies, keep clean URLs

#### DOI:
- Add if available
- Format: `doi = {10.1234/example},`

---

### Step 8: Add Missing Field Documentation

**IMPORTANT**: If any required or wanted fields are unavailable, document them in a `missing` field.

#### What to Document:
- **ALWAYS** document missing required and wanted fields
- **DO NOT** document missing optional fields unless they are truly expected
- The `missing` field helps track what information is unavailable, not what is simply optional

#### Format:
```bibtex
missing = nomonth # nodoi # nopublisher # noaddress
```

**Note**: No comma after the last item in the `missing` field if it's the last field in the entry.

#### Common missing values:
- `nodoi` - DOI not available
- `nourl` - URL not available (only if it's a wanted field)
- `nopages` - Page numbers not available
- `nomonth` - Month not available
- `nopublisher` - Publisher not specified
- `noaddress` - Address/location not available
- `nochapterno` - Chapter number not available

#### Important Rules:
1. **For `@inproceedings`**: `publisher` is a **wanted field** (not optional) and must be documented if missing. `address` is optional.
2. **Never shorten page numbers**: Always use full page numbers (e.g., `685--689`, NOT `685--89`)
3. **Only add `renamedFrom`**: When an existing key that's already in use is being changed - NOT for new entries being added for the first time

#### Examples:

**Workshop paper with missing fields:**
```bibtex
@inproceedings{MVV:StarAI16,
	author = {Meert, Wannes and Vlasselaer, Jonas and Van den Broeck, Guy},
	title = {{A Relaxed Tseitin Transformation for Weighted Model Counting}},
	booktitle = StarAI,
	pages = {1--7},
	year = 2016,
	url = {https://lirias.kuleuven.be/retrieve/390200},
	missing = nomonth # nodoi
}
```

**Conference paper with publisher missing:**
```bibtex
@inproceedings{SGEL:MODELS09,
	author = {Schwanninger, Christa and Groher, Iris and Elsner, Christoph and Lehofer, Martin},
	title = {{Variability Modelling Throughout The Product Line Lifecycle}},
	booktitle = MODELS,
	pages = {685--689},
	year = 2009,
	missing = nomonth # nodoi # nopublisher
}
```

---

### Step 9: Verify Field Order

Fields should be in this order (for `@inproceedings`):
1. `renamedFrom` (if applicable)
2. `author`
3. `title`
4. `booktitle`
5. `pages`
6. `month`
7. `year`
8. `doi`
9. `url`
10. `missing` (if applicable)
11. Other fields (alphabetically)

---

## Complete Example Transformation

### Before (Inconsistent):
```bibtex
@inproceedings{MdBS+:08,
	author = {Wannes Meert and Jonas Vlasselaer Guy Van den Broeck and Computer Science and Department Computer and Science Department},
	title = {{A Relaxed Tseitin Transformation for Weighted Model Counting}},
	booktitle = {Proceedings of the Sixth International Workshop on Statistical Relational AI (StarAI)},
	pages = {1--7},
	url = {\$$Uhttps://lirias.kuleuven.be/retrieve/390200$\$Dmeert\%5Fstarai16.pdf [freely available]},
	year = 2008
}
```

### After (Corrected):
```bibtex
@inproceedings{MVV:StarAI16,
	renamedFrom = {MVV:16},
	author = {Meert, Wannes and Vlasselaer, Jonas and Van den Broeck, Guy},
	title = {{A Relaxed Tseitin Transformation for Weighted Model Counting}},
	booktitle = StarAI,
	pages = {1--7},
	year = 2016,
	url = {https://lirias.kuleuven.be/retrieve/390200},
	missing = nomonth # nodoi # nopublisher
}
```

**Changes made:**
- Fixed key from `MVV:16` to `MVV:StarAI16` (added venue abbreviation)
- Added `renamedFrom` field to track old key
- Fixed author names to `LastName, FirstName` format
- Removed institutional affiliations from authors
- Changed booktitle from literal string to BibTeX string `StarAI`
- Cleaned up URL
- Added `missing` field to document unavailable month and DOI

---

## Adding Venue Abbreviations

When a venue is not in the abbreviation files, you MUST add it to BOTH files AND update any existing entries that use this venue.

### Files to Update:
1. **`literature/MYabrv.bib`** - Long form with full title
2. **`literature/MYshort.bib`** - Short form abbreviation
3. **`literature/literature.bib`** - Update all entries using this venue

### Determine Venue Type:
- Conference
- Workshop
- Symposium
- Journal

### Adding to MYabrv.bib:

Find the correct section and add alphabetically by key:

**Conferences:**
```bibtex
@String{ICSE = "Proc.\ Int'l Conf.\ on Software Engineering (ICSE)"}
```

**Workshops:**
```bibtex
@String{StarAI = "Proc.\ Int'l Workshop on Statistical Relational AI (StarAI)"}
```

**Symposiums:**
```bibtex
@String{FSE = "Proc.\ Int'l Symposium on Foundations of Software Engineering (FSE)"}
```

**Journals:**
```bibtex
@String{TSE = "IEEE Trans.\ on Software Engineering (TSE)"}
```

### Format Guidelines:
- Use `Proc.\` for Proceedings
- Use `Int'l` for International
- Use `Conf.\` for Conference
- Use `Trans.\` for Transactions
- Include abbreviation in parentheses at end

### Adding to MYshort.bib:

Add corresponding short form in same section, same alphabetical position:

```bibtex
@String{StarAI = "StarAI"}
```

### Update Existing Entries in literature.bib:

**IMPORTANT**: After adding a new venue abbreviation, you MUST update all existing entries that reference this venue.

For each entry that uses the new venue:

1. **Update the entry key** to include the venue abbreviation:
   ```bibtex
   % Before
   @inproceedings{MVV:16,

   % After
   @inproceedings{MVV:StarAI16,
   	renamedFrom = {MVV:16},
   ```

2. **Update the booktitle/journal field** to use the BibTeX string:
   ```bibtex
   % Before
   booktitle = {Proceedings of the Sixth International Workshop on Statistical Relational AI (StarAI)},

   % After
   booktitle = StarAI,
   ```

3. **Add renamedFrom field** if you changed the key (so users can find the updated reference)

---

## Common Mistakes to Avoid

1. **DON'T** use hyphens `-` in pages, use double dash `--`
2. **DON'T** shorten page numbers (use `685--689`, NOT `685--89`)
3. **DON'T** use literal venue names, use BibTeX strings
4. **DON'T** forget to add venues to BOTH MYabrv.bib and MYshort.bib
5. **DON'T** forget to update existing entries after adding new venue abbreviations
6. **DON'T** use 2-digit years in the year field (only in key)
7. **DON'T** include affiliations in author field
8. **DON'T** forget double braces around titles
9. **DON'T** use commas between authors, use `and`
10. **DON'T** add `renamedFrom` for new entries - only when changing existing keys
11. **DON'T** forget to document missing `publisher` for `@inproceedings` (it's a wanted field)
12. **DON'T** treat `publisher` as optional for conference papers

---

## Verification Steps

After formatting an entry:

1. Run `./run sort` to sort and check formatting
2. Run `./run test` to validate all entries
3. Check console output for errors/warnings
4. Fix any issues reported
5. Repeat until clean

---

## Special Cases

### Theses:
- Key: Use last name only (e.g., `Smith:PhD23`)
- Month/Year: Use defense date
- Add `type = Bachelor`, `type = Master`, or use `@phdthesis`
- If not published: add `note = toappear` or `comments = nottobepublished,`
- If in German: add `note = {In German},`

### Unpublished Papers:
- Try to add DOI even if unpublished
- Helps track publication status

### Missing Information:
Use the `missing` field to document unavailable data:
```bibtex
missing = nodoi # nourl # nomonth,
```

Common missing flags:
- `nodoi`
- `nourl`
- `nopages`
- `nomonth`
- `nopublisher`
- `noaddress`
- `nochapterno`

---

## Field Type Reference

### @inproceedings:
**Required**: author, title, booktitle, year
**Wanted**: volume OR number, pages, publisher, month, url, doi
**Optional**: editor, series, address, organization, note

**Note**: `publisher` is a wanted field and must be documented with `missing` if unavailable. `address` is optional.

### @article:
**Required**: author, title, journal, year
**Wanted**: volume, number, pages, month, doi, url
**Optional**: publisher

### @phdthesis / @mastersthesis:
**Required**: author, title, school, year
**Wanted**: month, type, doi, url
**Optional**: address

---

## Quick Examples by Entry Type

### Conference Paper:
```bibtex
@inproceedings{KAK:ICSE08,
	author = {K\"{a}stner, Christian and Apel, Sven and Kuhlemann, Martin},
	title = {{Granularity in Software Product Lines}},
	booktitle = ICSE,
	pages = {311--320},
	month = may,
	year = 2008,
	doi = {10.1145/1368088.1368131},
}
```

### Journal Article:
```bibtex
@article{AB:TSE20,
	author = {Author, Alice and Author, Bob},
	title = {{Some Great Research}},
	journal = TSE,
	volume = 46,
	number = 5,
	pages = {123--145},
	month = may,
	year = 2020,
	doi = {10.1109/TSE.2020.12345},
}
```

### Journal Article (single author, journal not in abbreviation files):
```bibtex
@article{S:PDM09,
	author = {Semenov, Aleksandr Anatol'evich},
	title = {{About Tseitin transformation in logical equations}},
	journal = {Prikladnaya Diskretnaya Matematika},
	publisher = {Tomsk State University},
	number = 4,
	pages = {28--50},
	year = 2009,
	missing = novolume # nomonth # nodoi # nourl
}
```

### Workshop Paper:
```bibtex
@inproceedings{MVV:StarAI16,
	author = {Meert, Wannes and Vlasselaer, Jonas and Van den Broeck, Guy},
	title = {{A Relaxed Tseitin Transformation for Weighted Model Counting}},
	booktitle = StarAI,
	pages = {1--7},
	year = 2016,
	url = {https://lirias.kuleuven.be/retrieve/390200},
}
```

---

## Summary

The key principle: **Consistency is critical**. Always follow these workflows:
1. Fix key format (`AuthorAbbrev:Venue##`)
2. Fix author names (`LastName, FirstName and ...`)
3. Fix title (double braces `{{...}}`)
4. Replace literal venue names with BibTeX strings
5. Fix pages (use `--`)
6. Add proper year and month
7. **Add `missing` field** to document any unavailable required/wanted fields
8. Ensure correct field order
9. **When adding new venue abbreviations:**
   - Add to BOTH MYabrv.bib and MYshort.bib
   - Update ALL existing entries that use this venue
   - Update both the entry key and booktitle/journal field
   - Add `renamedFrom` field when changing keys

When in doubt, find a similar entry in `literature.bib` and follow its format!

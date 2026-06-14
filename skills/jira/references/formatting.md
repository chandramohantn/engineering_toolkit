# Jira Wiki Markup Formatting

Quick reference for Jira description and comment formatting.

## Text

| Markup | Result |
|--------|--------|
| `*bold*` | **bold** |
| `_italic_` | _italic_ |
| `-strikethrough-` | ~~strikethrough~~ |
| `+underline+` | underline |
| `{{monospace}}` | `monospace` |

## Headings

```
h1. Heading 1
h2. Heading 2
h3. Heading 3
```

## Lists

```
- bullet
- bullet
  - nested

# numbered
# numbered
```

## Links

```
[Link text|https://example.com]
[PROJ-123]                        (auto-links to issue)
```

## Code

```
{code:python}
def hello():
    print("world")
{code}

{noformat}
Plain preformatted text
{noformat}
```

## Tables

```
||Header 1||Header 2||
|Cell 1|Cell 2|
|Cell 3|Cell 4|
```

## Panels & Colors

```
{panel:title=Important}
Content here
{panel}

{color:red}Warning text{color}
```

## Mentions & Dates

```
[~username]            (mention user)
{date:2026-04-15}      (formatted date)
```

## Checkboxes (in descriptions)

Jira doesn't have native checkboxes in wiki markup. Use:
```
- (/) Done item
- (x) Failed item  
- ( ) Pending item
```

# Galewind Theme Sample

A Markdown file that exercises the theme's **bold**, _italic_, and **_bold-italic_** rules.

## Features

Inline `code spans` and [links](https://example.com) and [reference links][ref] render here.

> Blockquotes use a muted foreground.
>
> They can span multiple lines.

### Ordered list

1. First curated variant
2. Second variant
3. Third variant

### Unordered list

- Dark Rose
- Dark Sky
  - Nested item with `inline code`
- Black Sky

A fenced code block:

```ts
const accent: string = "#38BDF8";
function highlight(value: string): string {
  return value.toUpperCase();
}
```

A table:

| Variant    | Background | Accent  |
| ---------- | ---------- | ------- |
| Dark Rose  | `#18181B`  | Rose    |
| Black Sky  | `#000000`  | Sky     |

Text with ~~strikethrough~~ and a hard break.

---

Image reference: ![icon](../icon.png)

[ref]: https://example.com/reference "Reference title"

Title: HTML processing
Path-alias: /html-processing
Date: 2019-12-30 18:55:57-08:00
Entry-ID: 647
UUID: c8d833f8-73e9-556a-9eb6-93f33b551f25

How to configure HTML processing in templates

.....

## HTML and Markdown options

Anywhere that Markdown or HTML is processed from a content file, the following parameters apply:

* The standard [image rendition arguments](/image-renditions#arguments)
* **`absolute`**: Set to True to force all links to be absolute (rather than relative); for HTML, this applies to all `href`, `src`, and [rendition](322#rendition-attrs) attributes.
* **`markup`**: Whether to include any markup in the title; defaults to `True`, but should be set to `False` where HTML markup isn't valid.

    For example, markup isn't allowed in the HTML `<title>` tag:

    ```html
    <html>
    <head><title>{{ entry.title(markup=False) }}</title></head>
    <body><h1>{{ entry.title }}</h1></body>
    </html>
    ```

    Nor is it valid in HTML attributes:

    ```html
    <a href="{{category.link}}" title="{{category.description(markup=False)}}">{{category.name}}</a>
    <a href="{{entry.link}}" title="{{entry.title(markup=False)}}">{{entry.title}}</a>
    ```

    For the sake of improving readability, this will also remove the contents of `<del>` and `<s>` tags (such as what are rendered by Markdown `~~strikethrough~~`); for example,
        an entry title of `This is ~~not~~ a test` will render as `This is a test`. If you would like more control over this behavior, use the [`strip_html` filter](324#strip_html) instead.

## Markdown-only options

The following options only apply to Markdown content:

* **`smartquotes`**: Set to `True` to enable automatic smartquote substitution, or `False` to disable it (necessary in e.g. Atom feeds). Defaults to `True`.
* **`no_smartquotes`**: The opposite of `smartquotes`, provided for backwards compatibility; if `smartquotes` is set then this is ignored.
* **`markdown_extensions`**: A list of extensions to configure the Markdown formatter with; defaults to the global configuration.
* **`xhtml`**: Set to `True` to render as XHTML instead of HTML (default: `False`)

Note that an entry's title is always treated as Markdown, even if the entry itself is HTML.
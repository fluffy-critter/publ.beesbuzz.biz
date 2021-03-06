Title: View object
Path-Alias: /api/view
Date: 2018-04-25 15:03:55-07:00
Entry-ID: 150
UUID: d506b63c-dd77-4c7a-b06e-c381696c3cc2

The template API for view objects.

.....

The `view` object has the following things on it:

* <span id="entries">**`entries`**</span>: A list of all of the entries that are visible and authorized in this view

    Optionally takes a parameter, `unauthorized`, which indicates the maximum number of unauthorized entries which will be included. If this is a number, that number of unauthorized entries will be included; if True, *all* unauthorized entries will be included. These entries will count against the `count` limit, if any. Defaults to `0`.

    Iterating on the `view` itself is equivalent to iterating on its `entries` without any arguments.

* **`deleted`**: A list of all of the entries that were deleted from this view (with `Status: GONE` or `Status: DELETED`)

* <span id="unauthorized">**`unauthorized`**</span>: A list of entries which would be included if the user were authorized.

    This is mostly so that a template can indicate whether a logged-out user should try logging in to see the protected entries, or for feeds to show placeholders.

    Optionally takes a parameter, `count`, which indicates the maximum number that will be included. If not specified it will use the `count` limit, if any.

    Note that visible, authorized entries *do not* count against the limit.

* <span id="has_unauthorized">**`has_unauthorized`**</span>: Indicates whether the view has any entries which could become visible if a different user were logged in.

* **`count`**: The number of visible entries in the view

* **`last_modified`**: A last-modified time for this view (useful for feeds)

* **`spec`**: The view's specification (category, count, date, etc.)

    This is in the form of the arguments that would be passed to `get_view` to
    obtain this view. For example, you can use `'date' in view.spec` to determine
    whether a view is date-based.

* **`previous`**: The previous page for this view, based on the current sort order
* **`next`**: The next page for this view, based on the current sort order
* **`older`**: The previous page for this view, going back in time
* **`newer`**: The next page for this view, going forward in time

* **`current`**: The current/default page of this view; can take additional [restriction parameters](#subviews)
* **`is_current`**: Whether this view is the current/default page

* **`paging`**: Returns the type of pagination that is in effect for this view; one of:

    * **`offset`**: Based on entry offset
    * **`year`**: Based on the entry's publication year
    * **`month`**: Based on the entry's publication month
    * **`day`**: Based on the entry's publication day

    These values are the same as the `paging` parameter of [`entry.archive`](entry.md#archive.paging).

* <span id="all_pages">**`pages`**: A list of every page for this view based on the current pagination.</span>

    ==Note:== This will probably be *very slow*; use sparingly.

* **`link`**: The link to this view; optionally takes the following arguments:

    * **`category`**: Which category to use (defaults to the category this view is queried against)
    * **`template`**: Which template to use (defaults to the index template)
    * **`absolute`**: Whether the URL should be absolute or relative
        * **`False`**: Use a relative URL (default)
        * **`True`**: Use an absolute URL

* **`first`**: The first entry in the view
* **`last`**: The last entry in the view
* **`newest`**: The newest entry in the view
* **`oldest`**: The oldest entry in the view

* **`range`**: A textual description of the range of entries on this view, if the
    view has any sort of pagination-type constraints. Takes the following optional arguments:

    * **`day`**: The format to use for daily pagination, or a time period within a month; defaults to `YYYY/MM/DD`
    * **`week`**: The format to use for a weekly pagination; defaults to `YYYY/MM/DD`
    * **`month`**: The format to use for a monthly pagination, or a time period covering multiple months; defaults to `YYYY/MM`
    * **`year`**: The format to use for a yearly pagination, or a tim eperiod covering multiple years; defaults to `YYYY/MM`
    * **`span`**: The format to use for a range of entries where the first and last entry dates differ (after formatting);
        defaults to `{oldest} — {newest} ({count})`
    * **`single`**: The format to use for a range of entries where the first and last are within the same time period;
        defaults to `{oldest} ({count})`

    If there is only a single entry in the view, the `range` property will be formatted
    for its time period directly, and it only uses the `day`, `month`, or `year` format.

    If there are multiple entries, then the time period is chosen with the following logic:

    * If they are within the same month, it uses `day`
    * If they are within the same year (but on different months), it uses `month`
    * Otherwise, it uses `year`

    Both dates are formatted based on the format corresponding to the chosen
    period. If they are the same, the `single` format is used; otherwise the
    `span` format is used. Both of these formats receive the following template
    values:

    * **`oldest`**: The formatted date of the earliest entry
    * **`newest`**: The formatted date of the latest entry
    * **`count`**: The number of entries in the view

    The specified formats for `day` `month` and `year` can be as specific as you
    would like; for example, if you want to always show the months in question
    regardless of the span, you can set all three formats to `YYYY-MM`, or on
    the other end of the spectrum you could indicate the full format down to the
    nanosecond if you really want to for some reason.

    Any format string accepted by [Arrow](http://arrow.readthedocs.io/en/latest/#tokens)
    is acceptable (for example, `MMMM YYYY` will appear as `January 2012`).

* <span id="tags">**`tags`**: Any tags that are applied to this view, provided as a (possibly-empty) list.</span>

* **`tag_add`**: Generates a view with one or more tags added
* **`tag_remove`**: Generates a view with one or more tags removed
* **`tag_toggle`**: Generates a view with one or more tags toggled

    This is useful for a tag browser where you want to be able to toggle tags on and off; for example:

    ```jinja
    <ul>
    {% for name,count in category.tags %}
    <li><a href="{{view.tag_toggle(name)}}">{{name}}</a> ({{count}} entries)</li>
    {% endfor %}
    </ul>
    ```


### <span id="subviews">Getting subviews</span>

Any view object can also take arguments to further refine the view; the following
arguments are supported:


* **`category`**: The top-level categories to consider; can be a single category or a list of categories.

    Setting this to `None` will get entries from all categories; this is equivalent to `category='',recurse=True`

* **`category_not`**: Categories to exclude; this can be either a single category, or a list of categories.
* **`recurse`**: Whether to include subcategories.
    * `True`: Include subcategories
    * `False`: Do not include subcategories (default)
* **`future`**: Whether to include entries from the future.
    * `True`: Include future entries
    * `False`: Do not include future entries (default)
* **`date`**: Limit to entries based on a specified date; this can be of the format `YYYY`, `YYYY-MM`, or `YYYY-MM-DD`.
* **`count`**: Limit to a maximum number of entries.

    If `date` is set, `count` has no effect.

* **`entry_type`**: Limit to entries with a specific [`Entry-Type`](/entry-format#entry-type) header
* **`entry_type_not`**: Limit to entries which do NOT match a specific entry type

    These can be a single string, or it can be an array of strings. Note that
    these are case-sensitive (i.e. `"PaGe"` and `"pAgE"` are two different types).

    * `get_view(entry_type='page')`: only get entries of type "page"
    * `get_view(entry_type_not='page')`: only get entries which AREN'T of type "page"
    * `get_view(entry_type=['news','comic'])`: get entries which are of type 'news' or 'comic'
    * `get_view(entry_type_not=['news','comic'])`: get entries of all types except 'news' or 'comic'

    Mixing `entry_type` and `entry_type_not` results in undefined behavior, not that it makes
    any sense to do that anyway.

* **`tag`**: Limit the view to entries which match the listed tag(s).
* <span id="tag_filter">**`tag_filter`**</span>: What filter criterion to use for matching tags. One of:

    * **`'ANY'`**: All entries which have at least one of the listed tags (default); this can also be spelled `'OR'`
    * **`'ALL'`**: Entries which have all of the listed tags; this can also be spelled `'AND'`
    * **`'NONE'`**: Entries which have none of the listed tags'; this can also be spelled `'NOT'`

* **`start`**: Limit the view to start with this entry, regardless of sort order
* **`last`**: Limit the view such to none newer than the specified entry (by id or object)
* **`first`**: Limit the view such to none older than the specified entry
* **`before`**: Limit the view to only entries which came before the specified entry
* **`after`**: Limit the view to only entries which came after the specified entry
* <span id="order">**`order`**</span>: What sort order to provide the entries in; one of:

    * **`oldest`**: Oldest-first
    * **`newest`**: Newest-first (default)
    * **`title`**: Sorted alphabetically by title

* <span id="attachments">**`has_attachments`**</span>: Limit the view to entries with (if `True`) or without (if `False`) attachments
* **`is_attached`**: Limit the view to entries which are (if `True`) or are not (if `False`) attachments
* **`attachments`**: Limit the view to entries which are attachments of the specified entry
* **`attached`**: Limit the view to entries which have the specified entry attached

For example, this will print the titles of
the first 10 entries in the view, including subcategories:

```jinja
{% for entry in view(count=10,recurse=True) %}
    {{entry.title}}
{% endfor %}
```

If you want to use the same view refinement multiple times, you can use `{% set %}`:

```jinja
{% set content = view(count=10,recurse=True,entry_type_not='sidebar') %}
{% if content.entries %}
<ul>
{% for entry in content.entries %}
<li>{{entry.title}}</li>
{% endfor %}
</ul>
{% endif %}
```

#### <span id="get_view"></span> `view(...)` vs `get_view(...)`

The global `get_view()` function creates an entirely new view from scratch, rather
than basing it on the current default view. Some possible uses for this are:

* Getting a link to the latest entry on the entire site (e.g. `get_view().newest`)
* Properly showing the current category's sidebar links without filtering them by date or page (e.g. `get_view(category=category,entry_type='sidebar')`)

    Note that this can also be achieved with `view.current(entry_type='sidebar')`

* Having a global set of sidebar links (e.g. `get_view(entry_type='sidebar')`)



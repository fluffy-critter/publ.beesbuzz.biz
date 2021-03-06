Title: User configuration file
Tag: auth
Tag: config
Date: 2019-08-10 01:46:14-07:00
Entry-ID: 1341
UUID: 144f6409-7745-518c-bcbc-dc30050f8839

The file format for configuring user authentication.

.....

The authentication file, normally stored in `users.cfg` unless [configured differently](/api/python), stores a set of permissions groups for different authenticated users.

The format is pretty simple:

```cfg
[admin]
http://example.com/
mailto:me@example.com

[friends]
mailto:someone@example.com
mailto:someone-else@example.com
http://example.com/~friend/
good-friends

[enemies]
mailto:mark@facebook.com
http://tumblr.com/

[good-friends]
https://beesbuzz.biz/
```

Simply put, each group is indicated by `[group_name]`, and each line after the group name indicates the authenticated identities (and other groups) which are a part of that group. So, in this case, anyone who is in the `good-friends` group will also be in the `friends` group.  All identities are given as full URIs.

Identities can also be used as a group name, to help manage those folks who have more than one identity that you want to treat equivalently; for example:

```cfg
[https://beesbuzz.biz]
mailto:fluffy@beesbuzz.biz
; Twitter URLs *must* include the user ID; this helps prevent spoofing.
; You can get the full user URL from the authentication log (/_admin)
https://twitter.com/fluffy#993171
https://queer.party/@fluffy
```

This will give the identities `mailto:fluffy@beesbuzz.biz`, `https://twitter.com/fluffy#993171`, and `https://queer.party/@fluffy` membership in all groups that `https://beesbuzz.biz` is in as well.

Any identities which belong to the administrative group (which is `admin` by default but can configured differently) will have access to all entries, as well as the administrative dashboard. Otherwise, users are subject to the [permissions system](Entry file format.md#auth).

You can also start a line with `#` or `;` to indicate that it is a comment.

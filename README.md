# Problem

You want to see the tree of subdirectories of your current directory, yet you don't have **tree**
installed (or you don't want to install **tree** for some reason).

# Example

<pre>
.
└── matching
    ├── bib
    ├── data
    │   └── source
    │       └── html
    ├── data
    │   └── plots
    ├── method
    │   ├── info
    │   └── soft
    │       ├── imgs
    │       │   ├── ascii
    │       │   └── symbol
    │       └── js
    └── ms
</pre>

# Solution

The shell function defined here, **t**, will do the job. **t** shows only subdirectories, not
regular files. The function depends on POSIX **ls**, **grep**, **sed**, and **awk**.

If you want to use **t**, download the accompanying `t.sh` script and source it; or, copy the
function definition and paste it in your `.bashrc` or equivalent.

# Usage

`t` for the default tree; `t -a` to include hidden subdirectories; `t -n` to inhibit coloring; `t
-na` or `t -an` to include hidden subdirectories and inhibit coloring.

## Note

Although more performant than **t**, other solutions published at:

[Stack Overflow](https://stackoverflow.com/questions/3455625/)

do not produce really good-looking results because they transform the output of `ls -R` line-by-line
from top to bottom. In a tree of subdirectories, however, the decorations in any branch depend on
the branches below it. **t** solves the issue by processing the output of `ls -R` from the last line
to the first.


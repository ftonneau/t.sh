# t: list subdirectories in tree-like format.
# Author: Francois Tonneau

# Options: -a ('all'): include hidden paths; -n: no color.
# Usage: t [-a|-n|-an|-na]

t()
{
    local options=$1
    #
    # -q: replace bad chars by '?'; -L: follow links; -R: recursive listing;
    # -a: will include hidden paths. All of this is POSIX.
    local flags=-qLR
    case $options in
        -a | -an | -na) flags=-aqLR ;;
    esac
    local coloring=yes
    case $options in
        -n | -an | -na) coloring=no ;;
    esac
    #
    # Keep only sub-list headings (^./foo...:) and format them.
    ls $flags 2>/dev/null \
    | grep '^./' \
    | sed -e 's,:$,,' \
    | awk -v coloring="$coloring" '
        function tip(new) { stem = substr(stem, 1, length(stem) - 4) new }
        {
            path[NR] = $0
        }
        END {
            elbow = "└── "; pipe = "│   "; tee = "├── "; blank = "    "
            none = ""
            path_hue = 4
            if (coloring == "yes") {
                color = "\033[1;3" path_hue "m"; nocolor = "\033[m"
            }
            else {
                color = ""; nocolor = ""
            }
            #
            # Model each stem on the previous one, going bottom up.
            for (row = NR; row > 0; row--) {
                #
                # gsub: count (and clean) all slash-ending components; hence,
                # reduce path to its last component.
                growth = gsub(/[^/]+\//, "", path[row]) - slashes
                if (growth == 0) {
                    tip(tee)
                }
                else if (growth > 0) {
                    if (stem) tip(pipe) # if...: stem is empty at first!
                    for (d = 1; d < growth; d++) stem = stem blank
                    stem = stem elbow
                }
                else {
                    tip(none)
                    below = substr(stem, length(stem) - 4, 4)
                    if (below == blank) tip(elbow); else tip(tee)
                }
                path[row] = stem color path[row] nocolor
                slashes += growth
            }
            root = "."; print color root nocolor
            for (row = 1; row <= NR; row++) print path[row]
        }
    '
}


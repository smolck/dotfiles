#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#63f2f1aa'  # default
T='#63f2f1aa'  # text
W='#cbe3e7aa'  # wrong
V='#63f2f1aa'  # verifying

i3lock \
-n \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--blur 5              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--keylayout 2

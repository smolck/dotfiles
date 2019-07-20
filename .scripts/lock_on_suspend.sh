#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#100e23CC'  # default
T='#100e23CC'  # text
W='#cbe3e7aa'  # wrong
V='#100e23CC'  # verifying
IN='#a6b3ccCC'

i3lock \
-n \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$C    \
--ringcolor=$D        \
--linecolor=$C       \
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
--keylayout 2 \

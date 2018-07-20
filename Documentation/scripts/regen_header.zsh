#!zsh
DIR=${1:-.}
find "${DIR}" -name '*.ebuild' -print0 | xargs -0 sed -r -e "1i# Copyright 1999-$(date +%Y) Gentoo Foundation" -e "1i# Distributed under the terms of the GNU General Public License v2" -e "1,3{/^#/d}" -e "4,5{/^EAPI=/s|=[[:punct:]]*([[:digit:]]*)[[:punct:]]*|=\1|g}" -i

#!/bin/sh

find . -name '*.ebuild' -and -not -name '*-9999*' | \
{ [[ $@ ]] && grep $@ || cat; } | \
xargs -I{} ebuild {} digest

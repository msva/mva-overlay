#!/bin/sh

find . -iname '*.ebuild' | \
{ [[ $@ ]] && grep $@ || cat; } | \
xargs -I{} ebuild {} digest

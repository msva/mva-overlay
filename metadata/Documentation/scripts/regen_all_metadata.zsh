#!/bin/zsh

REPO_ROOT="${$(git rev-parse --show-toplevel):-.}"

find . -mindepth 3 -maxdepth 3 -type f -name 'metadata.xml' | \
{ [[ $@ ]] && grep $@ || cat; } | \
xargs -I{} lua ${REPO_ROOT}/Documentation/scripts/update_metadata_xml.lua {}

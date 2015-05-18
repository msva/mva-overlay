#!/bin/sh

find * -type f -name '*.ebuild' -print0 | xargs -0 sed -r -e "s/Copyright 1999-20[0-9]{2}/Copyright 1999-$(date +%Y)/" -e 's/.*Header: .*/# $Header: This ebuild is from mva overlay; $/' -e 's/EAPI=.*/EAPI="5"/' -i

#!/bin/sh

find * -type f -print0 | xargs -0 sed -r "s/Copyright 1999-20[0-9]{2}/Copyright 1999-$(date +%Y)/" -i


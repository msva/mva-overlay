#!/usr/bin/awk -f

BEGIN {
    var = ""
    in_breaked_line = 0
}

{
    if ( in_breaked_line ) {
        # skip comments
        if ( match($0, "^ *#", a) != 0 ) {
            print
            next
        }

        # a[1] = line; a[2] = last char
        if ( match($0, "(.*)(.)", a) == 0) {
            in_breaked_line = 0 # precaution
            print
            next
        }

        # check if we're still in a breaked statement
        if ( a[2] != "\\" )
            in_breaked_line = 0

        print var,"+=",( in_breaked_line ? a[1] : $0 )
        next
    }

    if( match($0, "^ *([A-Z_]*)[^=]*=(.*)\\\\$", a) == 0 ) {
        # if not a first line of a breaked statement
        print
    } else {
        # we're on a first line of a breaked statement
        in_breaked_line = 1
        # set variable name
        var = a[1]

        print var,"+=",a[2]
    }
}

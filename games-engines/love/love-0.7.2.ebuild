# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="An *awesome* framework you can use to make 2D games in Lua."
HOMEPAGE="http://love2d.org/"
SRC_URI="http://bitbucket.org/rude/love/downloads/${P}-linux-src.tar.gz"

LICENSE="ZLIB/LIBPNG"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="dev-games/physfs
        dev-lang/lua
        media-libs/devil[mng,tiff]
        media-libs/freetype
        media-libs/libmodplug
        media-libs/libsdl[joystick,opengl]
        media-libs/libvorbis
        media-libs/openal
        media-sound/mpg123
        virtual/opengl"
DEPEND="${RDEPEND}
        media-libs/libmng
        media-libs/tiff"

S=${WORKDIR}/${PN}-HEAD

DOCS=( "readme.txt" "changes.txt" )
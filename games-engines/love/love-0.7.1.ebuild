# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games

DESCRIPTION="An *awesome* framework you can use to make 2D games in Lua."
HOMEPAGE="http://love2d.org/"
SRC_URI="http://bitbucket.org/rude/love/downloads/${P}-linux-src.tar.gz"

LICENSE="ZLIB/LIBPNG"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

DEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-sound
	virtual/opengl
	media-libs/openal
	luajit? ( dev-lang/luajit )
	!luajit? ( dev-lang/lua )
	media-libs/devil
	media-libs/libmng
	media-libs/tiff
	>=media-libs/freetype-2
	dev-games/physfs
	media-libs/libmodplug
	media-sound/mpg123
	media-libs/libvorbis"
RDEPEND="${DEPEND}"

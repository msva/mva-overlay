# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="3"
# we've waiting for porting games.eclass to EAPI4

inherit games eutils autotools mercurial

DESCRIPTION="An *awesome* framework you can use to make 2D games in Lua."
HOMEPAGE="http://love2d.org/"
EHG_REPO_URI="https://bitbucket.org/rude/love"
SRC_URI=""
KEYWORDS=""


LICENSE="ZLIB"
SLOT="0"
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

DOCS=( "readme.md" "changes.txt" )

src_prepare() {
	sh platform/unix/gen-makefile || die
	mkdir platform/unix/m4 || die
	eautoreconf
}

src_configure() {
	OPTS=()
	use luajit && OPTS+=" --with-luajit"
	OPTS+=" --disable-dependency-tracking --disable-option-checking"
	econf ${OPTS}
}

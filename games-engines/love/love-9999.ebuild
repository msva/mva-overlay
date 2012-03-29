# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="An *awesome* framework you can use to make 2D games in Lua."
HOMEPAGE="http://love2d.org/"
if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="mercurial"
	EHG_REPO_URI="https://bitbucket.org/rude/love"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://bitbucket.org/rude/love/downloads/${P}-linux-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi;

inherit games eutils autotools ${SCM_ECLASS}

LICENSE="ZLIB"
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
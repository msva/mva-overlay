# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MPV_REQ_USE="cplugins(+),libmpv"
inherit mpv-plugin toolchain-funcs

DESCRIPTION="MPRIS plugin for mpv"
HOMEPAGE="https://github.com/hoyon/mpv-mpris"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hoyon/${PN}"
else
	if [[ ${PV} == *_pre* ]]; then
		MY_SHA=16fee38988bb0f4a0865b6e8c3b332df2d6d8f14
		S="${WORKDIR}/${PN}-${MY_SHA}"
	fi
	SRC_URI="https://github.com/hoyon/${PN}/archive/${MY_SHA:-${PV}}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"

RDEPEND="
	dev-libs/glib:2
	media-video/ffmpeg:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

MPV_PLUGIN_FILES=( mpris.so )

src_compile() {
	tc-export CC
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

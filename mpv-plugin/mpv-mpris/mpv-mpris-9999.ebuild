# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

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
		MY_SHA=df95f07c48926d1589ee5fe36a455c1f49cbe4c8
		S="${WORKDIR}/${PN}-${MY_SHA}"
	fi
	SRC_URI="https://github.com/hoyon/${PN}/archive/${MY_SHA:-${PV}}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
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

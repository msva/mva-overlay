# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Simple PNG library"
HOMEPAGE="https://libspng.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/randy408/libspng"
else
	SRC_URI="https://github.com/randy408/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64 ~arm ~arm64"
fi

LICENSE="BSD"
SLOT="0"

IUSE="static-libs examples miniz threads optimizations"

RDEPEND="
	miniz? ( dev-libs/miniz )
	!miniz? ( sys-libs/zlib )
"

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature threads multithreading)
		$(meson_use examples build_examples)
		$(meson_use miniz use_miniz)
		$(meson_use static-libs static_zlib)
		$(meson_use optimizations enable_opt)
	)
	meson_src_configure
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="GIF encoder written in C"
HOMEPAGE="https://github.com/dloebl/cgif"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dloebl/cgif"
else
	SRC_URI="https://github.com/dloebl/${PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="sys-libs/zlib"

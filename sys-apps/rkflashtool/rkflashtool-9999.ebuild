# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool for flashing Rockchip devices"
HOMEPAGE="https://sourceforge.net/projects/rkflashtool/"

LICENSE="BSD-2"
SLOT="0"

if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/Git"
else
	KEYWORDS="~amd64"
	SRC_URI="mirror://sourceforge/project/${PN}/${P}/${P}-src.tar.xz"
	S="${WORKDIR}/${P}-src"
fi

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

DOCS=( README )

src_prepare() {
	sed -r -i \
		-e '1,8s@(^CC[\t\ ]*)=@\1?=@' \
		-e '1,8s@(^LD[\t\ ]*)=@\1?=@' \
		-e '1,8s@(^CFLAGS[\t\ ]*)=@\1?=@' \
		-e '1,8s@(^LDFLAGS[\t\ ]*)=@\1?=@' \
		-e '1,8s@(^PREFIX[\t\ ]*)\?=.*$@\1= usr@' \
		Makefile || die
	tc-export CC
	tc-export LD
	default
}

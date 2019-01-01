# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Another (FUSE based) union filesystem"
HOMEPAGE="https://github.com/trapexit/mergerfs"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""
#IUSE="man-regen"
EGIT_REPO_URI="https://github.com/trapexit/mergerfs"

RDEPEND="
	sys-apps/attr:=
	>=sys-apps/util-linux-2.18
	sys-devel/gettext:=
"
#	sys-fs/fuse[static-libs]:=

#TODO:
#	1) unbundle fuse
#	2) optional man regen

DEPEND="
	${RDEPEND}
"
#	man-regen? ( app-text/pandoc )

src_install() {
	dobin mergerfs
	dodoc README.md
	doman man/mergerfs.1
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Another (FUSE based) union filesystem"
HOMEPAGE="https://github.com/trapexit/mergerfs"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/trapexit/mergerfs"
else
	SRC_URI="https://github.com/trapexit/mergerfs/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
#IUSE="man-regen"

RDEPEND="
	sys-apps/attr:=
	>=sys-apps/util-linux-2.18
	sys-devel/gettext:=
"

DEPEND="
	${RDEPEND}
"

#TODO: optional man regen
#	man-regen? ( app-text/pandoc )

src_install() {
	dobin mergerfs
	dosym mergerfs /usr/bin/mount.mergerfs
	dodoc README.md
	doman man/mergerfs.1
}

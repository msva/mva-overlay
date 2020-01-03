# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"

HOMEPAGE="https://github.com/sdhand/x11fs"
EGIT_REPO_URI="https://github.com/sdhand/x11fs.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	x11-libs/libxcb
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install || die "emake install failed"
}

pkg_postinst() {
	einfo "How to mount:"
	einfo
	einfo "mount -t fuse x11fs <path>/<to>/<mountpoint>"
}

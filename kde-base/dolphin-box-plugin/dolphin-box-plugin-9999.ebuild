# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=4

KMNAME="kdesdk"
inherit kde4-meta git

DESCRIPTION="Provides Dropbox integration in Dolphin."
EGIT_REPO_URI="git://anongit.kde.org/scratch/trichard/dolphin-box-plugin"
SRC_URI=""
HOMEPAGE="http://gitweb.kde.org/scratch/trichard/dolphin-box-plugin.git"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
LICENSE="GPL-3"

DEPEND="
	$(add_kdebase_dep libkonq)
"
RDEPEND="${DEPEND}
	dev-vcs/git
"
#	$(add_kdebase_dep kompare)

src_unpack() {
	git_src_unpack
}

src_prepare() {
        git_src_prepare
        cd "${S}"
        cmake-utils_src_configure || die "cmake failed"
}

pkg_postinst() {
	elog ""
	elog "Quick start:"
	elog "  * Restart Dolphin"
	elog "  * Settings --> Configure Dolphin --> Services"
	elog "  * Check Dropbox"
	elog "  * Restart Dolphin"
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit kde4-base git-2

DESCRIPTION="Provides Dropbox integration in Dolphin."
EGIT_REPO_URI="git://anongit.kde.org/scratch/trichard/dolphin-box-plugin"
SRC_URI=""
HOMEPAGE="http://gitweb.kde.org/scratch/trichard/dolphin-box-plugin.git"
KEYWORDS=""
IUSE=""
LICENSE="GPL-3"

RDEPEND="kde-base/kdelibs:4"
DEPEND="dev-vcs/git"

#src_unpack() {
#	git_src_unpack
#}

src_prepare() {
	git-2_src_prepare
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

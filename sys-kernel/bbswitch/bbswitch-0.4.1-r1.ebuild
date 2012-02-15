# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Toggle the discrete graphics card"
HOMEPAGE="https://github.com/Bumblebee-Project/bbswitch"

if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="git-2"
	EGIT_REPO_URI="https://github.com/Bumblebee-Project/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Bumblebee-Project/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi;

inherit eutils linux-mod ${SCM_ECLASS}

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/linux-sources
	sys-kernel/linux-headers"

RDEPEND=""

MODULE_NAMES="bbswitch(kernel/drivers/acpi)"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_TARGETS="default"
}

src_install() {
	insinto /etc/modprobe.d
	newins "${FILESDIR}"/bbswitch.modprobe bbswitch.conf || die
	linux-mod_src_install
}
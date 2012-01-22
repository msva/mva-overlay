# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Few modules for ACPI debugging"
HOMEPAGE="https://github.com/Lekensteyn/acpi-stuff"

if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="git-2"
	EGIT_REPO_URI="https://github.com/Lekensteyn/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Lekensteyn/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi;

inherit eutils linux-mod ${SCM_ECLASS}

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/linux-sources
	sys-kernel/linux-headers"

RDEPEND=""

MODULE_NAMES="acpi_dump_info(kernel/drivers/acpi:${S}/acpi_dump_info) pcidev(kernel/drivers/acpi:${S}/pcidev)"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_TARGETS="default"
}

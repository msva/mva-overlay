# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod

DESCRIPTION="Few modules for ACPI debugging"
HOMEPAGE="https://github.com/Lekensteyn/acpi-stuff"

if [[ ${PV} =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Lekensteyn/${PN}.git"
else
	SRC_URI="https://github.com/downloads/Lekensteyn/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
LICENSE="GPL-2"

DEPEND="
	virtual/linux-sources
	sys-kernel/linux-headers
"

MODULE_NAMES="acpi_dump_info(kernel/drivers/acpi:${S}/acpi_dump_info) pcidev(kernel/drivers/acpi:${S}/pcidev)"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_TARGETS="default"
}

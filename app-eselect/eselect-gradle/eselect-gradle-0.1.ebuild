# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manage multiple Gradle versions on one system"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	doins "${FILESDIR}/gradle.eselect"
}

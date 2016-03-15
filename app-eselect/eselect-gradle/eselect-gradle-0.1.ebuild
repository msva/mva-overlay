# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Manage multiple Gradle versions on one system"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	doins "${FILESDIR}/gradle.eselect"
}

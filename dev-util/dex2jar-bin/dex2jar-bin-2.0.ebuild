# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN%%-bin}"
DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/pxb1988/dex2jar"
SRC_URI="https://github.com/pxb1988/${MY_PN}/releases/download/${PV}/dex-tools-${PV}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( virtual/jre virtual/jdk )"
DEPEND="!!${CATEGORY}/${MY_PN}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	local dir="/opt/${PN}"

	exeinto "${dir}"
	doexe *.sh
	exeinto "${dir}/lib"
	doexe lib/*.jar

	dosym "${dir}/d2j-${MY_PN}.sh" "/usr/bin/${MY_PN}"
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV1="${PV/_pre*/-SNAPSHOT}"
MY_PV2="${MY_PV1}-2021-10-31"

DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/pxb1988/dex2jar"
SRC_URI="https://github.com/pxb1988/${PN%%-bin}/releases/download/v${MY_PV2}/dex-tools-${MY_PV2}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( virtual/jre virtual/jdk )"
DEPEND="!!dev-util/dex2jar"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/dex-tools-${MY_PV1}"

src_install() {
	local dir="/opt/${PN}"

	exeinto "${dir}"
	doexe *.sh
	exeinto "${dir}/lib"
	doexe lib/*.jar

	dosym "${dir}/d2j-${PN}.sh" "/usr/bin/${PN%%-bin}"
}

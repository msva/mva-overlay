# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2

MY_PN="${PN//-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Android Dex to Java Decompiler"
HOMEPAGE="https://github.com/skylot/jadx"
SRC_URI="https://github.com/skylot/${MY_PN}/releases/download/v${PV}/${MY_P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/jre:*"
DEPEND="
	${RDEPEND}
	!!dev-util/jadx
"

S=${WORKDIR}

src_install() {
	insinto /opt/jadx/lib/
	doins "${S}"/lib/*
	java-pkg_regjar "${D}"/opt/jadx/lib/*.jar
	java-pkg_dolauncher ${MY_PN} --main jadx.cli.JadxCLI
	java-pkg_dolauncher ${MY_PN}-gui --main jadx.gui.JadxGUI
}

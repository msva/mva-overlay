# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils git-r3 java-pkg-2

DESCRIPTION="Universal Database Manager"
HOMEPAGE="http://dbeaver.jkiss.org/"
EGIT_REPO_URI="https://github.com/serge-rider/dbeaver"
KEYWORDS=""
SLOT="0"

LICENSE="GPL-2"

IUSE="firebird informix mssql mysql oracle postgres sybase"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/maven-bin:*
"
RDEPEND="
	${DEPEND}
	postgres? ( dev-java/jdbc-postgresql )
	mysql? ( dev-java/jdbc-mysql )
	mssql? ( dev-java/jdbc-mssqlserver )
	sybase? ( dev-java/jtds )
	informix? ( dev-java/jdbc-informix )
	firebird? ( dev-java/jdbc-jaybird )
"
#	oracle? ( dev-java/jdbc-oracle-bin )
# Banned in gentoo ^^^

src_compile() {
	mvn package
}

src_install() {
	local dir="/usr/share/${PF}"
	local arch="${ARCH/amd/x86_}"
	local ins="product/standalone/target/products/org.jkiss.dbeaver.core.product/linux/gtk/${arch}/${PN}"
	insinto "${dir}"
	exeinto "${dir}"
	doins -r "${ins}"/*
	doexe "${ins}/${PN}"
	doicon "${ins}/${PN}.png"
	newicon "${ins}/icon.xpm" "${PN}.xpm"
	make_wrapper "${PN}" "./${PN} -data ~/.config/${PN}" "${dir}"
	make_desktop_entry "${PN}" "${PN}" "${PN}"
	default
}

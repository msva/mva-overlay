# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2

DESCRIPTION="A tool for reverse engineering 3rd party, closed, binary Android apps"
HOMEPAGE="https://code.google.com/p/android-apktool/"
SRC_URI="https://bitbucket.org/iBotPeaches/apktool/downloads/${PN}_${PV/_}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/jdk:1.7"
DEPEND=""

S="${WORKDIR}"

RESTRICT="test"

src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }

src_install() {
	java-pkg_newjar "${DISTDIR}/${A}"
	java-pkg_dolauncher ${PN} --java_args "-Xmx512M"
}

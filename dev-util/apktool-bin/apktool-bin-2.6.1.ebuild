# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="A tool for reverse engineering 3rd party, closed, binary Android apps"
HOMEPAGE="https://ibotpeaches.github.io/Apktool/"
SRC_URI="https://github.com/iBotPeaches/Apktool/releases/download/v${PV}/${PN%%-bin}_${PV/_}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.7"
DEPEND="!!${CATEGORY}/${PN%%-bin}"

S="${WORKDIR}"

RESTRICT="test"

src_install() {
	java-pkg_newjar "${DISTDIR}/${A}"
	java-pkg_dolauncher ${PN%%-bin} --java_args "-Xmx512M"
}

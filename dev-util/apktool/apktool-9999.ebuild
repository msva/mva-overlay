# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 git-r3

DESCRIPTION="A tool for reverse engineering 3rd party, closed, binary Android apps"
HOMEPAGE="https://ibotpeaches.github.io/Apktool/"
EGIT_REPO_URI="https://github.com/iBotPeaches/Apktool"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jdk-1.7"
DEPEND="
	!${CATEGORY}/${PN}-bin
	virtual/gradle
"

#S="${WORKDIR}/${P^}"

RESTRICT="test"

src_prepare() {
	rm -r brut.apktool/apktool-lib/src/test
	# ^ wants to connect to X11 -> fails -> brakes build

	default
	java-pkg-2_src_prepare
}
src_compile() {
	TERM=dumb gradle --console=rich build shadowJar proguard
}

src_install() {
	java-pkg_newjar "brut.apktool/apktool-cli/build/libs/${PN}-cli-all.jar"
	java-pkg_dolauncher ${PN} --java_args "-Xmx512M"
}

# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8
inherit java-pkg-2 gradle

DESCRIPTION="A tool for reverse engineering 3rd party, closed, binary Android apps"
HOMEPAGE="https://apktool.org/"

if [[ "${PV}" =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iBotPeaches/Apktool"
else
	SRC_URI="https://github.com/iBotPeaches/Apktool/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P^}"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=">=virtual/jdk-1.7"
DEPEND="
	!!${CATEGORY}/${PN}-bin
	virtual/gradle
"

src_prepare() {
	rm -r brut.apktool/apktool-lib/src/test
	# ^ wants to connect to X11 -> fails -> brakes build

	default
	java-pkg-2_src_prepare
}
src_compile() {
	egradle build shadowJar proguard
}

src_install() {
	java-pkg_newjar "brut.apktool/apktool-cli/build/libs/${PN}-cli-all.jar"
	java-pkg_dolauncher ${PN} --java_args "-Xmx512M"
}

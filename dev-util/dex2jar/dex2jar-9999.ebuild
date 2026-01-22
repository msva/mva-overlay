# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit gradle

DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/pxb1988/dex2jar"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ThexXTURBOXx/${PN}"
else
	MY_MAGIC="-2021-10-31"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pxb1988/${PN}/archive/v${PV/_pre*/-SNAPSHOT${MY_MAGIC}}.tar.gz -> ${P}.tar.gz"
fi

DEPEND="virtual/gradle"
RDEPEND="
	dev-java/antlr:3.5
	|| ( virtual/jre virtual/jdk )
"

src_prepare() {
	default
	sed -r \
		-e '/com.google.android.tools:dx:23.0.0/d' \
		-i dex-tools/build.gradle || die
	# TODO:
	# 1) try to use dx.jar from android-sdk-update-manager's downloaded android tools
	# 2) migrate to some fork with fixed issues
}

src_compile() {
	# assemble -> shadowJar?
	egradle assemble
}

src_install() {
	local dir="/usr/share/${P}"

	exeinto "${dir}"
	doexe dex-tools/build/generated-sources/bin/*.sh

	rm */build/libs/*-sources.jar
	insinto "${dir}/lib"
	doins */build/libs/*.jar

	dosym "${dir}/d2j-${PN}.sh" "/usr/bin/${PN}"
}

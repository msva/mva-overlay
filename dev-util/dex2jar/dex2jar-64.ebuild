# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gradle

DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/ThexXTURBOXx/dex2jar"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ThexXTURBOXx/${PN}"
else
	SRC_URI="https://github.com/ThexXTURBOXx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="virtual/gradle"
RDEPEND="
	dev-java/antlr:3.5
	|| ( virtual/jre virtual/jdk )
"

src_prepare() {
	default
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

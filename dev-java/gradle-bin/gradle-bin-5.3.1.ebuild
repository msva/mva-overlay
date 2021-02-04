# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV/_rc/-rc-}"

DESCRIPTION="A project automation and build tool with a Groovy based DSL"
SRC_URI="http://services.gradle.org/distributions/${MY_P}-all.zip"
HOMEPAGE="http://www.gradle.org/"
LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/zip
	app-eselect/eselect-gradle"
RDEPEND=">=virtual/jdk-1.6"

IUSE="source doc examples"

S="${WORKDIR}/${MY_P}"

src_install() {
	local gradle_dir="${EROOT:-}usr/share/${PN}-${SLOT}"

	dodoc getting-started.html

	insinto "${gradle_dir}"

	# source
	if use source ; then
		java-pkg_dosrc src/*
	fi

	# docs
	if use doc ; then
		java-pkg_dojavadoc docs
	fi

	# examples
	if use examples ; then
		java-pkg_doexamples samples
	fi

	insinto "${gradle_dir}"
	doins -r bin/ lib/
	fperms 755 "${gradle_dir}/bin/gradle"
	dosym "${gradle_dir}/bin/gradle" "/usr/bin/${P}"
}

pkg_postinst() {
	eselect gradle update ifunset
}

pkg_postrm() {
	eselect gradle update ifunset
}

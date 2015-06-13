# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_PV="${PV/_rc/-rc-}"
MY_PV="${MY_PV/_pre/-}+0000"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="A project automation and build tool similar to Apache Ant and Apache Maven with a Groovy based DSL"
SRC_URI="http://services.gradle.org/distributions-snapshots/${MY_P}-all.zip"
HOMEPAGE="http://www.gradle.org/"
LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"

DEPEND="
	app-arch/zip
	app-eselect/eselect-gradle
"
RDEPEND=">=virtual/jdk-1.5"

IUSE="source doc examples"

S="${WORKDIR}/${MY_P}"

src_install() {
	local gradle_dir="${EROOT}usr/share/${PN}-${SLOT}"

	dodoc changelog.txt getting-started.html

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

	# jars in lib/
	# Note that we can't strip the version from the gradle jars,
	# because then gradle won't find them.
	cd lib || die "lib/ not found"
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	# plugins in lib/plugins
	cd plugins
	java-pkg_jarinto ${JAVA_PKG_JARDEST}/plugins
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	java-pkg_dolauncher "${P}" --main org.gradle.launcher.GradleMain --java_args "-Dgradle.home=${gradle_dir}/lib \${GRADLE_OPTS}"
}

pkg_postinst() {
	eselect gradle update ifunset
}

pkg_postrm() {
	eselect gradle update ifunset
}

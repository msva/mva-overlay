# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 gradle

DESCRIPTION="A project automation and build tool with a Groovy based DSL"
HOMEPAGE="https://gradle.org/"
# SRC_URI="https://github.com/gradle/gradle-distributions/releases/download/v${PV}/${P%.0}-src.zip"
SRC_URI="https://github.com/gradle/gradle/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="${PV}"

KEYWORDS="~amd64"
RDEPEND="virtual/jre:*"

#KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
#RDEPEND=">=virtual/jre-9:*"
# ^ actually, it REQUIRES jdk/jre-9+ for build, but currently
# corresponding virtuals are masked (and gentoo-vm flag on
# jre/jdk ebuilds of 9+ versions is also masked)

DEPEND="
	${RDEPEND}
	app-arch/zip
	app-eselect/eselect-gradle
"
BDEPEND="app-arch/unzip"

IUSE="doc"

# S="${WORKDIR}/${PN}-${PV%.0}" # for "distributions" zip

src_prepare() {
#	(
#		echo TERM=dumb
#		echo "test -t 1 && GRADLE_OPTS=\"\${GRADLE_OPTS} -Dorg.gradle.console=rich\""
#	) >> "${T}"/gradle_term_hacks
##	^ - runtime workaround of https://github.com/gradle/gradle/issues/4426
	default
	java-pkg-2_src_prepare
}

src_compile() {
	local inst_target="install"
	use doc && inst_target="installAll"
#	TERM=dumb ./gradlew --console=rich --gradle-user-home "${WORKDIR}" "${inst_target}" -Pgradle_installPath=dist \
#		|| die 'Gradle build failed'
##	^^^^^^^^^ - buildtime workaround of https://github.com/gradle/gradle/issues/4426
	EGRADLE_BIN="./gradlew" egradle "${inst_target}" \
		-Pgradle_installPath=dist \
		-Dorg.gradle.ignoreBuildJavaVersionCheck=true # see https://github.com/msva/mva-overlay/issues/186
}

src_install() {
	local gradle_dir="/usr/share/${PN}-${SLOT}"

	insinto "${gradle_dir}"

	# jars in lib/
	# Note that we can't strip the version from the gradle jars,
	# because then gradle won't find them.
	cd dist/lib;
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	# plugins in lib/plugins
	cd plugins;
	java-pkg_jarinto ${JAVA_PKG_JARDEST}/plugins
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	java-pkg_dolauncher "${P}" \
		--main org.gradle.launcher.GradleMain \
		--java_args "-Dgradle.home=${gradle_dir}/lib \${GRADLE_OPTS}"
			#\
#		-pre "${T}"/gradle_term_hacks
}

pkg_postinst() {
	eselect gradle update ifunset
}

pkg_postrm() {
	eselect gradle update ifunset
}

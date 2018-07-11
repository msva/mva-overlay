# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DISTUTILS_OPTIONAL=yes
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} pypy{,3} )
RUBY_OPTIONAL=yes
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit distutils-r1 ruby-ng java-pkg-opt-2 eutils autotools git-r3

DESCRIPTION="Tools for reading and writing Data Matrix barcodes"
HOMEPAGE="http://www.libdmtx.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dmtx/dmtx-wrappers"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE="vala java php ruby python lua doc"

RDEPEND="
	=media-libs/libdmtx-${PV}
	vala? ( dev-lang/vala:* )
	java? ( >=virtual/jre-1.6:* )
	ruby? ( virtual/rubygems dev-ruby/rmagick )
	python? ( ${PYTHON_DEPS} )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Ruby wrapper currently fails to build with 1.9.
# Mono wrapper currently is Windows-only thing.
# Cocoa wrapper is for iOS.
# Bundled PHP wrapper is deprecated. Recommended to use external.
# Lua wrapper — to be done.

DEPEND="
	java? ( >=virtual/jdk-1.6:* )
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${P}"

ruby_wrapper_compile() {
	RUBY_ECONF="${RUBY_ECONF} ${EXTRA_ECONF}"
	${RUBY} extconf.rb \
		${RUBY_ECONF} || die "extconf.rb failed"
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" DLDFLAGS="${LDFLAGS}" "$@" || die "Ruby wrapper compilation failed"
}

ruby_wrapper_install() {
	make DESTDIR="${D}" "$@" install || die "Ruby wrapper install failed"
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf

	use python && (
		S="${S}/python"
		cd "${S}"
		distutils-r1_src_prepare
	)
	use ruby && (
		cp -r "${S}/ruby" "${WORKDIR}/all"
		ruby-ng_src_prepare
	)
}

src_compile() {
	default
	use java && (
		einfo "Compiling wrapper for Java"
		S="${S}/java"
		cd "${S}"
		emake || die "Java emake failed!"
	)

	use ruby && (
		einfo "Compiling wrapper for Ruby"
		_ruby_each_implementation ruby_wrapper_compile
	)
	use python && (
		einfo "Compiling wrapper for Python"
		S="${S}/python"
		cd "${S}"
		distutils-r1_src_compile
	)
}

src_install() {
	default
	use java && (
		einfo "Installing wrapper for Java"
		S="${S}/java"
		cd "${S}"
		java-pkg_dojar dmtx.jar
		use doc && (
			newdoc "${S}"/README README.java
		)
	)

	use ruby && (
		einfo "Installing wrapper for Ruby"
		 _ruby_each_implementation ruby_wrapper_install
		use doc && (
			newdoc "${S}"/README README.ruby
		)
	)

	use python && (
		einfo "Installing wrapper for Python"
		S="${S}/python"
		cd "${S}"
		distutils-r1_src_install
		use doc && (
			newdoc "${S}"/README README.python
		)
	)

	use vala && (
		einfo "Installing wrapper for Vala"
		S="${S}/vala"
		cd "${S}"
		insinto /usr/share/vala
		doins libdmtx.vapi
		use doc && (
			newdoc "${S}"/README README.vala
		)
	)
	find "${D}" -name '*.la' -delete || die
}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_OPTIONAL=yes
RUBY_OPTIONAL=yes
USE_RUBY="ree18 ruby18 jruby rbx"

inherit python-distutils-ng ruby-ng java-pkg-opt-2 git-2

DESCRIPTION="Tools for reading and writing Data Matrix barcodes"
HOMEPAGE="http://www.libdmtx.org/"
SRC_URI=""
EGIT_REPO_URI="git://libdmtx.git.sourceforge.net/gitroot/libdmtx/${PN}"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

IUSE="vala java php ruby python lua doc"

RDEPEND="
	=media-libs/libdmtx-${PV}
	vala? ( dev-lang/vala )
	java? ( >=virtual/jre-1.6 )
	php? ( dev-php/php-dmtx[doc=] )
	ruby? ( virtual/rubygems dev-ruby/rmagick !!=dev-lang/ruby-1.9* )
	python? ( dev-lang/python )
	lua? ( dev-lua/lua-dmtx[doc=] )"

# Ruby wrapper currently fails to build with 1.9.
# Mono wrapper currently is Windows-only thing.
# Cocoa wrapper is for iOS.
# Bundled PHP wrapper is deprecated. Recommended to use external.
# Lua wrapper — to be done.

DEPEND="
	java? ( >=virtual/jdk-1.6 )
	${RDEPEND}
	dev-util/pkgconfig
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
	use java && (
		rm "${S}/java/Makefile";
		cp "${FILESDIR}/java.Makefile" "${S}/java/Makefile";
	)
	use python && (
		S="${S}/python"
		cd "${S}"
		python-distutils-ng_src_prepare
	)
	use ruby && (
		cp -r "${S}/ruby" "${WORKDIR}/all"
		ruby-ng_src_prepare
	)
}

src_compile() {
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
		python-distutils-ng_src_compile
	)
}

src_install() {
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
		python-distutils-ng_src_install
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
}
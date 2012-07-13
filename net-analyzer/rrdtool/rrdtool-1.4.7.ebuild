# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/rrdtool/rrdtool-1.4.7.ebuild,v 1.2 2012/06/09 13:30:11 maksbotan Exp $

EAPI="4"

GENTOO_DEPEND_ON_PERL="no"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit eutils distutils flag-o-matic multilib perl-module autotools

DESCRIPTION="A system to store and display time-series data"
HOMEPAGE="http://oss.oetiker.ch/rrdtool/"
SRC_URI="http://oss.oetiker.ch/rrdtool/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="dbi doc lua perl python ruby rrdcgi tcl tcpd"

# This versions are minimal versions upstream tested with.
RDEPEND="
	>=media-libs/libpng-1.5.10
	>=dev-libs/libxml2-2.7.8
	>=x11-libs/cairo-1.10.2[svg]
	>=dev-libs/glib-2.28.7
	>=x11-libs/pango-1.28
	lua? ( || ( virtual/lua >=dev-lang/lua-5[deprecated] dev-lang/luajit:2 ) )
	perl? ( dev-lang/perl )
	ruby? ( >=dev-lang/ruby-1.8.6_p287-r13 )
	tcl? ( dev-lang/tcl )
	tcpd? ( sys-apps/tcp-wrappers )
	dbi? ( dev-db/libdbi )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/gawk"

DISTUTILS_SETUP_FILES=("bindings/python|setup.py")

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	epatch	"${FILESDIR}"/0001_"${P}"-configure.ac.patch
	epatch	"${FILESDIR}/${PN}"-1.4.5-automake-1.11.2.patch
	sed -i '/PERLLD/s:same as PERLCC:same-as-PERLCC:' configure.ac #281694

	# Python bindings are built/installed manually
	sed -e "/^all-local:/s/ @COMP_PYTHON@//" -i bindings/Makefile.am

	eautoreconf
}

src_configure() {
	filter-flags -ffast-math

	export RRDDOCDIR=${EPREFIX}/usr/share/doc/${PF}

	# to solve bug #260380
	[[ ${CHOST} == *-solaris* ]] && append-flags -D__EXTENSIONS__

	# Stub configure.ac
	local myconf=()
	if ! use tcpd; then
		myconf+="--disable-libwrap"
	fi
	if ! use dbi; then
		myconf+="--disable-libdbi"
	fi

	econf \
		--disable-static \
		$(use_enable rrdcgi) \
		$(use_enable lua) \
		$(use_enable lua lua-site-install) \
		$(use_enable ruby) \
		$(use_enable ruby ruby-site-install) \
		$(use_enable perl) \
		$(use_enable perl perl-site-install) \
		--with-perl-options=INSTALLDIRS=vendor \
		$(use_enable tcl) \
		$(use_with tcl tcllib "${EPREFIX}"/usr/$(get_libdir)) \
		$(use_enable python) \
		${myconf[@]}
}

src_compile() {
	emake LUA_INSTALL_CMOD="/usr/$(get_libdir)/lua/5.1" LUA_INSTALL_LMOD="/usr/share/lua/5.1/" || die "make install failed"
	use python && distutils_src_compile
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if ! use doc ; then
		rm -rf "${ED}"usr/share/doc/${PF}/{html,txt}
	fi

	if use !rrdcgi ; then
		# uses rrdcgi, causes invalid shebang error in Prefix, useless
		# without rrdcgi installed
		rm -f "${ED}"usr/share/${PN}/examples/cgi-demo.cgi
	fi

	if use perl ; then
		perl_delete_localpod
		perl_delete_packlist
	fi

	use python && distutils_src_install

	dodoc CHANGES CONTRIBUTORS NEWS README THREADS TODO

	find "${ED}"usr -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	use python && distutils_pkg_postinst

	ewarn "Since version 1.3, rrdtool dump emits completely legal xml.  Basically this"
	ewarn "means that it contains an xml header and a DOCTYPE definition.  Unfortunately"
	ewarn "this causes older versions of rrdtool restore to be unhappy."
	ewarn
	ewarn "To restore a new dump with an old rrdtool restore version, either remove"
	ewarn "the xml header and the doctype by hand (both on the first line of the dump)"
	ewarn "or use rrdtool dump --no-header."
	ewarn
	ewarn ">=net-analyzer/rrdtool-1.3 does not have any default font bundled. Thus if"
	ewarn ">you've upgraded from rrdtool-1.2.x and don't have any font installed to make"
	ewarn ">lables visible, please, install some font, e.g.  media-fonts/dejavu."
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}

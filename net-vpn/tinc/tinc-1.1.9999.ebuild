# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit systemd eutils python-any-r1 multilib git-r3 autotools patches

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="https://tinc-vpn.org/"

EGIT_BRANCH="1.1"
EGIT_REPO_URI="https://tinc-vpn.org/git/tinc"
EGIT_MIN_CLONE_TYPE="single"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="gui +legacy libressl +lzo +ncurses +readline +ssl tools uml vde upnp +zlib"
#gcrypt

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	lzo? ( dev-libs/lzo:2 )
	ncurses? ( sys-libs/ncurses:0 )
	readline? ( sys-libs/readline:0 )
	upnp? ( net-libs/miniupnpc )
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${DEPEND}
	vde? ( net-misc/vde )
	${PYTHON_DEPS}
	gui? ( $(python_gen_any_dep '
		dev-python/wxpython[${PYTHON_USEDEP}]
	') )
"

#REQUIRED_USE="^^ ( ssl gcrypt )"

src_prepare() {
	patches_src_prepare

	use tools && sed -r \
		-e '1,5s@^(sbin_PROGRAMS.*)@\1 $(EXTRA_PROGRAMS)@' \
		-i src/Makefile.am

	eautoreconf
}

src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}"/var
		--enable-jumbograms
		--disable-silent-rules
		--disable-tunemu
		--with-systemd="$(systemd_get_systemunitdir)"
#		$(use_with gcrypt libgcrypt) # Broken
		$(use_enable legacy legacy-protocol)
		$(use_enable lzo)
		$(use_enable ncurses curses)
		$(use_enable readline)
		$(use_enable uml)
		$(use_enable vde)
		$(use_enable upnp miniupnpc)
		$(use_enable zlib)
		$(use_with ssl openssl)
	)
	econf ${myconf[@]}
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/"${PN}"
	dodoc AUTHORS NEWS README THANKS
	dodoc doc/{CONNECTIVITY,NETWORKING,PROTOCOL,SECURITY2,SPTPS}
	dodoc -r doc/sample-config
	newinitd "${FILESDIR}"/tincd.init tincd
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd

	if use gui; then
		python_fix_shebang "${ED}"/usr/bin/"${PN}"-gui
		dodoc gui/README.gui
	else
		rm -f "${ED}"/usr/bin/"${PN}"-gui || die
	fi
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit systemd eutils python-any-r1 git-r3 autotools

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="http://www.tinc-vpn.org/"

EGIT_BRANCH="1.1"
EGIT_REPO_URI="https://tinc-vpn.org/git/tinc"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="+lzo +ncurses +openssl gcrypt gui +readline uml vde +zlib"
#upnp
# ^ broken
DEPEND="dev-libs/openssl:*
	lzo? ( dev-libs/lzo:2 )
	ncurses? ( sys-libs/ncurses:* )
	readline? ( sys-libs/readline:* )
	zlib? ( sys-libs/zlib )"
#	upnp? ( net-libs/miniupnpc )
# ^ broken
RDEPEND="${DEPEND}
	vde? ( net-misc/vde )
	${PYTHON_DEPS}
	gui? ( $(python_gen_any_dep '
		dev-python/wxpython[${PYTHON_USEDEP}]
		') )"

REQUIRED_USE="^^ ( openssl gcrypt )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-jumbograms \
		--disable-tunemu  \
		--with-windows2000 \
		--disable-silent-rules \
		$(use_enable lzo) \
		$(use_enable ncurses curses) \
		$(use_enable readline) \
		$(use_enable uml) \
		$(use_enable vde) \
		$(use_enable zlib) \
		$(use_with openssl) \
		${myconf}
#       $(use_with gcrypt libgcrypt), upstream not ready
#
#		$(use_enable upnp miniupnpc) \
# ^ broken
}

src_compile() {
	emake all ChangeLog || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/tinc
	dodoc AUTHORS ChangeLog COPYING.README NEWS README THANKS
	dodoc doc/{CONNECTIVITY,NETWORKING,PROTOCOL,SECURITY2,SPTPS}
	dodoc gui/README.gui
	dodoc -r doc/sample-config
	newinitd "${FILESDIR}"/tincd-r1 tincd
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd
	systemd_newunit "${FILESDIR}"/tincd_at.service 'tincd@.service'
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}

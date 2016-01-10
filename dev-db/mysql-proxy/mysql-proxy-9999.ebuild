# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit bzr eutils

DESCRIPTION="A Proxy for the MySQL Client/Server protocol"
HOMEPAGE="http://forge.mysql.com/wiki/MySQL_Proxy"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

EBZR_REPO_URI="lp:mysql-proxy"

#S=${WORKDIR}/${P}

RDEPEND="
	>=dev-libs/libevent-1.4
	>=dev-libs/glib-2.16
	|| (
		virtual/lua
		dev-lang/lua:0
		>=dev-lang/luajit-2
	)
"
DEPEND="${RDEPEND}
	>=virtual/mysql-5.0
	virtual/pkgconfig"
RESTRICT="test"

src_configure() {
	epatch "${FILESDIR}/fix_read_query_result_ignore.patch"
	./autogen.sh || die "could not autogen mysql-proxy"
	econf \
		--includedir=/usr/include/${PN} \
		--with-mysql \
		--with-lua \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd-9999 ${PN} || die
	dodoc ChangeLog NEWS README
	if use examples; then
		docinto examples
		dodoc examples/*.lua || die
		dodoc lib/*.lua || die
	fi
	# mysql-proxy will refuse to start unless the config file is at most 0660.
	insinto /etc/mysql
	insopts -m0660
	doins "${FILESDIR}"/${PN}.cnf || die
}

pkg_postinst() {
	einfo
	einfo "You might want to have a look at"
	einfo "http://dev.mysql.com/tech-resources/articles/proxy-gettingstarted.html"
	einfo "on how to get started with MySQL Proxy."
	einfo
}

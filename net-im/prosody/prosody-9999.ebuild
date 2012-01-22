# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib toolchain-funcs versionator mercurial

MY_PV=$(replace_version_separator 3 '')
DESCRIPTION="Prosody is a flexible communications server for Jabber/XMPP written in Lua."
HOMEPAGE="http://prosody.im/"
EHG_REPO_URI="http://hg.prosody.im/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+libevent mysql postgres sqlite +ssl +zlib +luajit ipv6"

DEPEND="net-im/jabber-base
		luajit? ( dev-lang/luajit:2 )
		!luajit? ( >=dev-lang/lua-5.1 )
		>=net-dns/libidn-1.1
		>=dev-libs/openssl-0.9.8"
RDEPEND="${DEPEND}
		dev-lua/luasocket
		ipv6? ( =dev-lua/luasocket-9999 )
		ssl? ( dev-lua/luasec )
		dev-lua/luaexpat
		dev-lua/luafilesystem
		mysql? ( >=dev-lua/luadbi-0.5[mysql] )
		postgres? ( >=dev-lua/luadbi-0.5[postgres] )
		sqlite? ( >=dev-lua/luadbi-0.5[sqlite] )
		libevent? ( dev-lua/luaevent )
		zlib? ( dev-lua/lua-zlib )"

S="${WORKDIR}/${PN}-${MY_PV}"

JABBER_ETC="/etc/jabber"
JABBER_SPOOL="/var/spool/jabber"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.8.0-cfg.lua.patch"
	sed -e "s!MODULES = \$(DESTDIR)\$(PREFIX)/lib/!MODULES = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!SOURCE = \$(DESTDIR)\$(PREFIX)/lib/!SOURCE = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!INSTALLEDSOURCE = \$(PREFIX)/lib/!INSTALLEDSOURCE = \$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!INSTALLEDMODULES = \$(PREFIX)/lib/!INSTALLEDMODULES = \$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e 's!\(os.execute(\)\(CFG_SOURCEDIR.."/../../bin/prosody"\)\();\)!\1"/usr/bin/prosody"\3!' -i util/prosodyctl.lua
	sed -e 's!\(desired_user = .* or "\)\(prosody\)\(";\)!\1jabber\3!' -i prosodyctl
	use luajit && sed -e "s!\(/usr/bin/env\) lua!\1 luajit!" -i prosody -i prosodyctl
}

src_configure() {
	# LuaJIT configuration feature (pkg-config is not in deps, since it is LuaJIT there)
	# and LuaJIT has pkg-config in deps ;)
	use luajit && myconf="--with-lua-include=$(pkg-config --variable includedir luajit)"
	# the configure script is handcrafted (and yells at unknown options)
	# hence do not use 'econf'
	./configure --prefix="/usr" \
		--sysconfdir="${JABBER_ETC}" \
		--datadir="${JABBER_SPOOL}" \
		--with-lua-lib=/usr/$(get_libdir)/lua \
		--c-compiler="$(tc-getCC)" --linker="$(tc-getCC)" \
		--cflags="${CFLAGS} -Wall -fPIC" \
		--ldflags="${LDFLAGS} -shared" \
		--require-config "${myconf}" || die "configure failed"
}

src_install() {
	DESTDIR="${D}" emake install || die "make failed"
	newinitd "${FILESDIR}/${PN}".initd ${PN}
}

src_test() {
	cd tests
	./run_tests.sh
}

pkg_postinst() {
	elog "Please note that the module 'console' has been renamed to 'admin_telnet'."
}

# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs mercurial

DESCRIPTION="Prosody is a flexible communications server for Jabber/XMPP written in Lua."
HOMEPAGE="http://prosody.im/"
EHG_REPO_URI="http://hg.prosody.im/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +libevent mysql postgres sqlite +ssl +zlib luajit ipv6 migration no-example-certs icu random-getrandom random-openssl"

DEPEND="
	virtual/lua[luajit=,bit]
	net-im/jabber-base
	!icu? ( >=net-dns/libidn-1.1:0 )
	icu? ( dev-libs/icu )
	|| (
		>=dev-libs/openssl-0.9.8z:0.9.8
		>=dev-libs/openssl-1.0.1j:0
	)
"

RDEPEND="
	${DEPEND}
	dev-lua/luasocket
	ipv6? ( dev-lua/luasocket )
	ssl? ( dev-lua/luasec )
	dev-lua/luaexpat
	dev-lua/luafilesystem
	mysql? ( >=dev-lua/luadbi-0.5[mysql] )
	postgres? ( >=dev-lua/luadbi-0.5[postgres] )
	random-getrandom? (
		>=sys-kernel/linux-headers-3.17
		>=sys-libs/glibc-2.25
	)
	sqlite? ( >=dev-lua/luadbi-0.5[sqlite] )
	libevent? ( dev-lua/luaevent )
	zlib? ( dev-lua/lua-zlib )
"

JABBER_ETC="/etc/jabber"
JABBER_SPOOL="/var/spool/jabber"

DOCS=( doc/ HACKERS AUTHORS )

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.8.0-cfg.lua.patch"
	sed -e "s!MODULES = \$(DESTDIR)\$(PREFIX)/lib/!MODULES = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i GNUmakefile
	sed -e "s!SOURCE = \$(DESTDIR)\$(PREFIX)/lib/!SOURCE = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i GNUmakefile
	sed -e "s!INSTALLEDSOURCE = \$(PREFIX)/lib/!INSTALLEDSOURCE = \$(PREFIX)/$(get_libdir)/!" -i GNUmakefile
	sed -e "s!INSTALLEDMODULES = \$(PREFIX)/lib/!INSTALLEDMODULES = \$(PREFIX)/$(get_libdir)/!" -i GNUmakefile
	sed -e 's!\(os.execute(\)\(CFG_SOURCEDIR.."/../../bin/prosody"\)\();\)!\1"/usr/bin/prosody"\3!' -i util/prosodyctl.lua
	sed -e 's!\(desired_user = .* or "\)\(prosody\)\(";\)!\1jabber\3!' -i prosodyctl

	use luajit && {
		find . -type f -name "*.lua" -print0 | xargs -0 sed -re "1s%#!.*%#!/usr/bin/env luajit%" -i
	}

	default
}

src_configure() {
	local lua=lua;
	local myconf=();

	use no-example-certs && myconf+=("--no-example-certs")

	use icu && myconf+=("--idn-library=icu")

	use random-getrandom && {
		ewarn "This build will not be supported by upstream"
		ewarn "random-* flags is meant as last resort for containers without /dev/urandom"

		myconf+=("--with-random=getrandom")
	}

	use random-openssl && {
		ewarn "This build will not be supported by upstream"
		ewarn "random-* flags is meant as last resort for containers without /dev/urandom"

		myconf+=("--with-random=openssl")
	}

	use luajit && {
		myconf+=("--lua-suffix=jit")
		lua=luajit;
	}

	# the configure script is handcrafted (and yells at unknown options)
	# hence do not use 'econf'

	my_econf() {
		echo "./configure ${@}"
		./configure "${@}"
	}

	my_econf --prefix="/usr" \
		--ostype=linux \
		--sysconfdir="${JABBER_ETC}" \
		--datadir="${JABBER_SPOOL}" \
		--libdir=/usr/$(get_libdir) \
		--c-compiler="$(tc-getCC)" --linker="$(tc-getCC)" \
		--cflags="${CFLAGS} -Wall -fPIC -std=c99" \
		--ldflags="${LDFLAGS} -shared" \
		--runwith="${lua}" \
		--with-lua-include="$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
		--with-lua-lib="$($(tc-getPKG_CONFIG) --variable libdir ${lua})" \
		"${myconf[@]}" || die "configure failed"
}

src_compile() {
	default
	use migration && (
		cd "${S}/tools/migration"
		emake || die "emake migrator fails"
	)
}

src_install() {
	local lua=lua
	use luajit && lua=luajit

	default
	newinitd "${FILESDIR}/${PN}".initd "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}".logrotate "${PN}"

	use migration && (
		cd "${S}/tools/migration"
		DESTDIR="${D}" emake install || die "migrator install failed"
		cd "${S}"
		rm -rf tools/migration
		insinto $($(tc-getPKG_CONFIG) ${lua} --variable INSTALL_LMOD)
		doins tools/erlparse.lua
		rm tools/erlparse.lua
		fowners "jabber:jabber" -R "/usr/$(get_libdir)/${PN}"
		fperms "775" -R "/usr/$(get_libdir)/${PN}"
		insinto "/usr/$(get_libdir)/${PN}"
		doins -r tools
	)
}

src_test() {
	cd tests
	./run_tests.sh
}

pkg_postinst() {
	use migration && (
		einfo 'You have enabled "migration" USE-flag.'
		einfo "If you want to migrate data from Ejabberd server, then"
		einfo "take a look at /usr/$(get_libdir)/${PN}/*{2,to}prosody.lua"
		einfo "migration scripts."
		einfo 'Also, you can find "prosody-migrator" binary as usefull'
		einfo "to migrate data from jabberd14, or between prosody files"
		einfo "storage and SQLite3."
	)
}

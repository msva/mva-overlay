# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="mercurial"

inherit lua

DESCRIPTION="LuaJIT FFI bindings to net-dns/unbound"
HOMEPAGE="http://code.zash.se/luaunbound/"
EHG_REPO_URI="http://code.zash.se/luaunbound/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
#IUSE="prosody"

RDEPEND="
	net-dns/unbound
"
#	prosody? ( net-im/prosody )
DEPEND="
	${RDEPEND}
"

DOCS=(README.markdown)

all_lua_prepare() {
	lua_default
	sed -r \
		-e "/^LUA_VERSION/s@5.2@\$\(LUA_IMPL\)\nLD=gcc@" \
		-e "/^CFLAGS/s@lua-@@" \
		-i GNUmakefile
}

each_lua_compile() {
	# If we have LuaJIT in the system — we'd prefer FFI version
	if ! lua_is_jit; then
		lua_default
	fi

#	if use prosody; then
#		lua_default prosody
#	fi
}

each_lua_install() {
	if lua_is_jit; then
		newlua_jit util.lunbound.lua lunbound.lua
	else
		dolua "lunbound.so"
	fi

#	if use prosody; then
#		insinto "/etc/jabber"
#		doins "use_unbound.lua"
#	fi
}

#pkg_postinst() {
#	if use prosody; then
#		einfo ""
#		einfo "Add following 3 lines to global section of your prosody.cfg.lua:"
#		echo 'RunScript "use_unbound.lua"'
#		echo 'resolvconf = "/etc/resolv.conf"'
#		echo 'hoststxt = "/etc/hosts"'
#		echo ''
#		einfo "Alternatively, you can customize resolv.conf and hosts files locations"
#	fi
#}

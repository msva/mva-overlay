# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="FFI-based OpenSSL binding for OpenResty"
HOMEPAGE="https://github.com/fffonion/lua-resty-openssl"
EGIT_REPO_URI="https://github.com/fffonion/lua-resty-openssl"

if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="v${PV}"
fi

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[nginx_modules_http_lua,ssl]
	dev-libs/openssl:0
"
DEPEND="
	${RDEPEND}
"

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

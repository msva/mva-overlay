# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Parse HTML text into a tree of elements with selectors"
HOMEPAGE="https://github.com/msva/lua-htmlparser"
EGIT_REPO_URI="https://github.com/msva/lua-htmlparser"

if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
	EGIT_COMMIT="v${PV}"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r src/*
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

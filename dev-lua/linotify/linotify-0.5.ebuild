# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="inotify bindings for Lua"
HOMEPAGE="https://github.com/hoelzro/linotify"
EGIT_REPO_URI="https://github.com/hoelzro/linotify"

if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
	EGIT_COMMIT="${PV}"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	virtual/libc
"
DEPEND="
	${RDEPEND}
"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake LUAPKG_CMD="${ELUA}"
	popd
}
each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins inotify.so
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

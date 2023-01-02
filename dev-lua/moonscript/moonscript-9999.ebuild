# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua-single git-r3

DESCRIPTION="A programmer friendly language that compiles into Lua."
HOMEPAGE="https://github.com/leafo/moonscript"
EGIT_REPO_URI="https://github.com/leafo/moonscript"

LICENSE="MIT"
SLOT="0"
IUSE="+inotify"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		|| (
			dev-lua/lpeg[${LUA_USEDEP}]
			dev-lua/lulpeg[${LUA_USEDEP},lpeg-replace]
		)
		dev-lua/luafilesystem[${LUA_USEDEP}]
		dev-lua/lua-argparse[${LUA_USEDEP}]
		inotify? ( dev-lua/linotify[${LUA_USEDEP}] )
	')
"
DEPEND="${RDEPEND}"

DOCS+=(docs/.)

src_compile() {
	${ELUA} bin/moonc moon/ moonscript/
	(
		echo "#!/usr/bin/env ${ELUA}"
		${ELUA} bin/moonc -p bin/moon.moon
		echo "-- vim: set filetype=lua:"
	) > bin/moon
	${ELUA} bin/moonc -p bin/splat.moon >> bin/splat
}

src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r moon{,script}{,.lua}
	dobin bin/{moon,moonc,splat}
	einstalldocs
}

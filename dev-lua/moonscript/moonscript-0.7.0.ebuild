# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua-single git-r3 toolchain-funcs

DESCRIPTION="A programmer friendly language that compiles into Lua"
HOMEPAGE="https://github.com/leafo/moonscript"
EGIT_REPO_URI="https://github.com/leafo/moonscript"

if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
	EGIT_COMMIT="v${PV}"
fi

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

# NOTE: preparation to EAPI9
# TODO: remove me on EAPI9 bump (when lua eclasses will support)
edo() {
	einfo ${*}
	${*}
}

src_compile() {
	edo $(tc-getCC) \
		-shared \
		-o moonscript/parse/native.so \
		${CFLAGS} ${LDFLAGS} \
		moonscript/parse/native.c \
		$(lua_get_CFLAGS) $(lua_get_LIBS)
	edo ${ELUA} bin/moonc moon/ moonscript/
	(
		echo "#!/usr/bin/env ${ELUA}"
		edo ${ELUA} bin/moonc -p bin/moon.moon
		echo "-- vim: set filetype=lua:"
	) > bin/moon
	edo ${ELUA} bin/moonc -p bin/splat.moon >> bin/splat
}

src_install() {
	insinto "$(lua_get_cmod_dir)/moonscript/parse"
	doins moonscript/parse/native.so
	rm moonscript/parse/native.so moonscript/parse/native.c || die
	insinto "$(lua_get_lmod_dir)"
	doins -r moon{,script}
	dobin bin/{moon,moonc,splat}
	einstalldocs
}

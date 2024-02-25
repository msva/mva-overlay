# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua-single git-r3

DESCRIPTION="Readline powered shell for LuaJIT"
HOMEPAGE="https://github.com/jdesgats/ILuaJIT"
EGIT_REPO_URI="https://github.com/jdesgats/ILuaJIT"

REQUIRED_USE="${LUA_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0"
IUSE="doc +completion"

RDEPEND="
	${LUA_DEPS}
$(lua_gen_cond_dep '
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
	dev-lua/penlight[${LUA_USEDEP}]
	sys-libs/readline:0
	completion? ( dev-lua/luafilesystem[${LUA_USEDEP}] )
')"
DEPEND="${RDEPEND}"

src_prepare() {
	if use doc; then
		ldoc . -d html
	fi
	default
}

src_install() {
	insinto $(lua_get_lmod_dir)
	doins *.lua
	dobin "${FILESDIR}/${PN}"
	if use doc; then
		HTML_DOCS=(html/.)
	fi
	einstalldocs
}

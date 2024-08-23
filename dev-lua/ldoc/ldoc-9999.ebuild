# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua-single git-r3

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://github.com/lunarmodules/ldoc"
EGIT_REPO_URI="https://github.com/lunarmodules/ldoc"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/penlight[${LUA_USEDEP}]
	')
"

DOCS=( README.md )

src_compile() {
	if use doc; then
			pushd ldoc &>/dev/null
			"${ELUA}" ../ldoc.lua . -d ../ldoc_html || die "Failed to build in ${doc} dir"
			popd &>/dev/null
	fi
	rm ldoc/{SciTE.properties,config.ld}
}

src_install() {
	# insinto "$(lua_get_lmod_dir)"
	# doins -r ldoc ldoc.lua
	# newbin ldoc.lua ldoc
	emake DESTDIR="${ED}" LUA_BINDIR="${EPREFIX}/usr/bin" LUA_SHAREDIR="$(lua_get_lmod_dir)" install
	if use doc; then
		HTML_DOCS=( ldoc_html/. )
	fi
	einstalldocs
}

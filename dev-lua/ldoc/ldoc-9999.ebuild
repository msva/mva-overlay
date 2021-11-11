# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://github.com/stevedonovan/LDoc/"
EGIT_REPO_URI="https://github.com/stevedonovan/LDoc/"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/penlight[${LUA_USEDEP}]
"

DOCS=( README.md doc/doc.md )

src_compile() {
	if use doc; then
		for doc in {,l}doc; do
			pushd "${doc}" &>/dev/null
			# "${ELUA}"
			lua ../ldoc.lua . -d ../${doc}_html || die "Failed to build in ${doc} dir"
			popd &>/dev/null
		done
	fi
	rm ldoc/{SciTE.properties,config.ld}
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r ldoc ldoc.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	newbin ldoc.lua ldoc
	if use doc; then
		HTML_DOCS=( doc_html/. ldoc_html/. )
	fi
	einstalldocs
}

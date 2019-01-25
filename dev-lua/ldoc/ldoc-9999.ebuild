# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="stevedonovan"
inherit lua

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://github.com/stevedonovan/LDoc/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/penlight
"

DOCS=( doc/doc.md readme.md )

HTML_DOCS=( doc_html/. ldoc_html/. )

all_lua_prepare() {
	local lua="$(lua_get_implementation)"

	mkdir -p doc_html/ ldoc_html/ # for USE=-doc case

	use doc && (
		for doc in {,l}doc; do
			pushd "${doc}" &>/dev/null
			"${lua}" ../ldoc.lua . -d ../${doc}_html || die "Failed to build in ${doc} dir"
			popd
		done
	)
	rm ldoc/{SciTE.properties,config.ld}

	lua_default
}

each_lua_install() {
	dolua ldoc ldoc.lua
}

all_lua_install() {
	newbin ldoc.lua ldoc
}

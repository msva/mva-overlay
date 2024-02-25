# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit mercurial lua

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-lua/verse
	dev-lua/luaexpat
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lua/squish
"

src_prepare() {
	use lua_targets_luajit && sed -r \
		-e '1s:(env lua):\1jit:' \
		-i clix.lua

	default
}

src_compile() {
	squish
}

src_install() {
	newbin clix.bin clix
	dodoc README
}

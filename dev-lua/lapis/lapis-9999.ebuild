# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="leafo"
inherit lua

DESCRIPTION="A web framework for Lua/MoonScript."
HOMEPAGE="https://github.com/leafo/lapis"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc moonscript"

RDEPEND="
	moonscript? ( dev-lua/moonscript )
	dev-lua/ansicolors
	dev-lua/luasocket
	dev-lua/luacrypto
	dev-lua/lua-cjson
	dev-lua/lpeg
	dev-lua/lua-rds-parser
	dev-lua/resty-upload
"
DEPEND="
	${RDEPEND}
"

DOCS=( docs/. README.md )

all_lua_prepare() {
	use moonscript || find "${S}" -type -name '*.moon' -delete
	lua_default
}

each_lua_compile() {
	use moonscript && lua_default build
}

each_lua_install() {
	use moonscript && dolua lapis.moon
	dolua lapis
}

all_lua_install() {
	dobin bin/lapis
}

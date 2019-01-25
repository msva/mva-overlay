# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="leafo"

inherit lua

DESCRIPTION="A programmer friendly language that compiles into Lua."
HOMEPAGE="https://github.com/leafo/moonscript"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+doc +inotify"

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
	dev-lua/luafilesystem
	dev-lua/argparse
	inotify? ( dev-lua/linotify )
"
DEPEND="${RDEPEND}"

DOCS=(docs/. README.md)

each_lua_compile() {
	local lua="$(lua_get_implementation)"
	${lua} bin/moonc moon/ moonscript/
}

all_lua_compile() {
	local lua="$(lua_get_implementation)"

	echo "#!/usr/bin/env lua" > bin/moon
	${lua} bin/moonc -p bin/moon.moon >> bin/moon
	echo "-- vim: set filetype=lua:" >> bin/moon

	${lua} bin/moonc -p bin/splat.moon >> bin/splat
}

each_lua_install() {
	dolua moon{,script}{,.lua}
}

all_lua_install() {
	dobin bin/{moon,moonc,splat}
}

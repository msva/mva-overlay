# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Lua programming language"
HOMEPAGE=""

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE="luajit bit bit32"

RDEPEND="
	!luajit? (
		|| (
			dev-lang/lua:5.1[deprecated]
			dev-lang/lua:5.2[deprecared]
			dev-lang/lua:5.3[deprecated]
		)
	)
	bit? (
		|| (
			dev-lang/luajit:2
			dev-lua/LuaBitOp
		)
	)
	bit32? (
		|| (
			dev-lang/lua:5.2[deprecated]
			dev-lang/lua:5.3[deprecated]
			dev-lua/bit32
		)
	)
	luajit? (
		dev-lang/luajit:2
		app-eselect/eselect-luajit
	)
	app-eselect/eselect-lua
	!!dev-lang/lua:0
"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

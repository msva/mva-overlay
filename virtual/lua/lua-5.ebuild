# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Virtual for Lua programming language"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="luajit bit bit32"

RDEPEND="
	!luajit? (
		|| (
			dev-lang/lua:5.1[deprecated,${MULTILIB_USEDEP}]
			dev-lang/lua:5.2[deprecared,${MULTILIB_USEDEP}]
			dev-lang/lua:5.3[deprecated,${MULTILIB_USEDEP}]
		)
	)
	bit? (
		|| (
			dev-lang/luajit:2
			dev-lua/LuaBitOp[${MULTILIB_USEDEP}]
		)
	)
	bit32? (
		|| (
			dev-lang/lua:5.2[deprecated,${MULTILIB_USEDEP}]
			dev-lang/lua:5.3[deprecated,${MULTILIB_USEDEP}]
			dev-lua/bit32[${MULTILIB_USEDEP}]
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

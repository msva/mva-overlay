# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit multilib-minimal

DESCRIPTION="Virtual for Lua programming language"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="luajit bit"

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
			dev-lang/lua:5.2[deprecated,${MULTILIB_USEDEP}]
			dev-lang/lua:5.3[deprecated,${MULTILIB_USEDEP}]
			dev-lang/luajit:2.0[${MULTILIB_USEDEP}]
			dev-lang/luajit:2.1[${MULTILIB_USEDEP}]
			dev-lua/LuaBitOp[${MULTILIB_USEDEP}]
		)
	)
	luajit? (
		|| (
			dev-lang/luajit:2.0[${MULTILIB_USEDEP}]
			dev-lang/luajit:2.1[${MULTILIB_USEDEP}]
		)
		app-eselect/eselect-luajit
	)
	app-eselect/eselect-lua
	!!dev-lang/lua:0
	!!dev-lang/luajit:2
"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

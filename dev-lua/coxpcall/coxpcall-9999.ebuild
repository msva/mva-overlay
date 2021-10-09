# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="keplerproject"
inherit lua-broken

DESCRIPTION="Lua coxpcall Library"
HOMEPAGE="https://github.com/keplerproject/coxpcall"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

HTML_DOCS=( doc/. )

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	dolua src/*
}

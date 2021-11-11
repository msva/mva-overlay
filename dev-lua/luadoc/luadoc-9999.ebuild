# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LuaDoc is obsolete, use LDoc instead"
HOMEPAGE="https://github.com/keplerproject/luadoc"

LICENSE="MIT"
SLOT="0"

pkg_pretend() {
	die "LuaDoc is obsolete, use LDoc instead."
}

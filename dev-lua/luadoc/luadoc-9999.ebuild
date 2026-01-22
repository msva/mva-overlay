# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="LuaDoc is obsolete, use LDoc instead"
HOMEPAGE="https://github.com/keplerproject/luadoc"

LICENSE="MIT"
SLOT="0"

pkg_pretend() {
	die "LuaDoc is obsolete, use LDoc instead."
}

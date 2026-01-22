# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua5-3 )

inherit lua-single git-r3

DESCRIPTION="Session library for OpenResty implementing Secure Cookie Protocol"
HOMEPAGE="https://github.com/WeirdConstructor/lal"
EGIT_REPO_URI="https://github.com/WeirdConstructor/lal"

LICENSE="MIT"
SLOT="0"
IUSE="doc"

REQUIRED_USE="${LUA_REQUIRED_USE}"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

DOCS=(README.md doc/.)

src_prepare() {
	sed -e "1i#!/usr/bin/env ${ELUA}" -i repl.lua
	default
}

src_install() {
	newbin repl.lua "${PN}"
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".lua
	insinto "$(lua_get_lmod_dir)/${PN}"
	doins *.lua lang util
	einstalldocs
}

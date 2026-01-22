# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake git-r3 patches

DESCRIPTION="Tox plugin for WeeChat"
HOMEPAGE="https://github.com/haavard/tox-weechat"
EGIT_REPO_URI="https://github.com/haavard/tox-weechat"

LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	sed -i \
		-e '/enum TOX_/s@enum TOX_@TOX_@' \
		"${S}/src/twc-commands.c" "${S}/src/twc-utils".{c,h} "${S}/src/twc-tfer".{c,h} "${S}/src/twc-tox-callbacks.c"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_PATH="/usr/$(get_libdir)/weechat/plugins"
	)
	cmake_src_configure
}

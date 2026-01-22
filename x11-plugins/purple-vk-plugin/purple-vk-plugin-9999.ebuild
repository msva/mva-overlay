# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake git-r3

DESCRIPTION="Pidgin plugin for vk.com social network"
HOMEPAGE="https://github.com/SergeyDjam/purple-vk-plugin"

EGIT_REPO_URI="https://github.com/SergeyDjam/purple-vk-plugin"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	net-im/pidgin
	>=dev-libs/libxml2-2.7
	sys-devel/gettext
"

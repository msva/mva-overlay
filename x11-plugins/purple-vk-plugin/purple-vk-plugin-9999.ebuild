# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Pidgin plugin for vk.com social network"
HOMEPAGE="https://bitbucket.org/olegoandreev/purple-vk-plugin https://github.com/SergeyDjam/purple-vk-plugin"

EGIT_REPO_URI="https://github.com/SergeyDjam/purple-vk-plugin"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	net-im/pidgin
	>=dev-libs/libxml2-2.7
	sys-devel/gettext
"

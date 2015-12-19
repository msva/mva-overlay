# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils mercurial

DESCRIPTION="Pidgin plugin for vk.com social network"
HOMEPAGE="https://bitbucket.org/olegoandreev/purple-vk-plugin"

EHG_REPO_URI="https://bitbucket.org/olegoandreev/purple-vk-plugin"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	net-im/pidgin
	>=dev-libs/libxml2-2.7
	sys-devel/gettext
"

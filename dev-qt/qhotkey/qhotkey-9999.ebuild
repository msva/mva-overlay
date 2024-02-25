# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A global shortcut/hotkey library for desktop Qt applications"
HOMEPAGE="https://github.com/skycoder42/QHotkey"

MY_PN="QHotkey"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Skycoder42/${MY_PN}.git"
else
	SRC_URI="https://github.com/Skycoder42/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD-with-attribution"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"

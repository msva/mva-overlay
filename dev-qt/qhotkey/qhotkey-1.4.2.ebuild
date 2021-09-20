# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A global shortcut/hotkey library for desktop Qt applications"
HOMEPAGE="https://skycoder42.github.io/QHotkey"

MY_PN="QHotkey"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/Skycoder42/${MY_PN}.git"
else
	SRC_URI="https://github.com/Skycoder42/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD-with-attribution"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5/5.9
	dev-qt/qtgui:5/5.9
"
RDEPEND="${DEPEND}"

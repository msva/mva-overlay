# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ECM_QTHELP="true"
# ECM_TEST="true" # build system adds autotests dir based on BUILD_TESTING value
KFMIN=6.3.0
QTMIN=6.5.0
inherit ecm kde.org

DESCRIPTION="UnifiedPush client components"
HOMEPAGE="https://community.kde.org/KUnifiedPush"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	# SRC_URI="mirror://kde/stable/${PN}/src/${P}.tar.xz"
	SRC_URI="https://invent.kde.org/libraries/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
elif [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://invent.kde.org/libraries/${PN}.git"
fi

LICENSE="CC0-1.0"
SLOT="6"

# had no time to look for it
RESTRICT="test"

DEPEND="
	dev-qt/qtbase[dbus,gui]
	dev-qt/qtwebsockets:6
	kde-frameworks/kservice:6
	kde-frameworks/kcmutils:6
"
RDEPEND="${DEPEND}"

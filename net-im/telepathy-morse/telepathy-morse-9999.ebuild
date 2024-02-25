# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Telegram connection manager for Telepathy."
HOMEPAGE="https://github.com/TelepathyIM/telepathy-morse"
#EGIT_REPO_URI="git://anongit.kde.org/telepathy-morse"
EGIT_REPO_URI="https://github.com/TelepathyIM/telepathy-morse"

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="
	net-libs/telegram-qt
	>=net-libs/telepathy-qt-0.9.6.0
"
DEPEND="${RDEPEND}
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=OFF
		-DENABLE_TESTAPP=OFF
		-DENABLE_EXAMPLES=OFF
		-DDESIRED_QT_VERSION=5
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

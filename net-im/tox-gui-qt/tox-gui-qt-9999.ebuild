# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/nurupo/ProjectTox-Qt-GUI"

inherit cmake-utils git-2

DESCRIPTION="A front end for ProjectTox Core written in Qt5 and C++."
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="
	net-im/tox-core
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_prepare() {
	:
}

pkg_postinst() {
        elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
        elog "or in #tox @ irc.freenode.org"
}
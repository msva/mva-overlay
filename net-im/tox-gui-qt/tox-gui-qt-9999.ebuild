# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/nurupo/ProjectTox-Qt-GUI"

inherit git-2 cmake-utils

DESCRIPTION="A front end for ProjectTox Core written in Qt5 and C++."
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	net-libs/libsodium
	net-im/tox-core
	dev-qt/qtdeclarative:5
	dev-qt/qtwidgets:5
"

src_prepare() {
	die "Unfortunately, I've not so much time to finish this ebuild for now. Any contributions is accepted at my e-mail."
}

src_configure() {
}

src_install() {
}

pkg_postinst() {
}

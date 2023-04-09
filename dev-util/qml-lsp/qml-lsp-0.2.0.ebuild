# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# i chose to interpret the version as one = 0.1.0, two = 0.2.0, …
MY_V="rjienrlwey-number-two"

DESCRIPTION="Collection of QML tools, including qml-lsp, qml-dap, and qml-refactor-fairy"
HOMEPAGE="https://invent.kde.org/sdk/qml-lsp"
SRC_URI="
	https://invent.kde.org/sdk/${PN}/-/archive/${MY_V}/${PN}-${MY_V}.tar.bz2
	https://tastytea.de/files/gentoo/${P}-vendor.tar.xz
"
S="${WORKDIR}/${PN}-${MY_V}"

# NOTE: Generate vendor tarball like this:
#       go mod vendor && cd ..
#       tar -caf ${P}-vendor.tar.xz qml-lsp-rjienrlwey-*/vendor

LICENSE="GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/tree-sitter"
RDEPEND="
	${DEPEND}
	dev-qt/qtcore
"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-0.2.0-find-qmake5.patch )

src_compile() {
	ego build -ldflags '-linkmode external'
}

src_test() {
	ego test
}

src_install() {
	dobin ${PN}
	einstalldocs
}

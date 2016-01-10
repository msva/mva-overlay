# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-r3

RESTRICT="strip"

DESCRIPTION="dependency tool for go"
HOMEPAGE="https://github.com/tools/godep"
EGIT_REPO_URI="https://github.com/tools/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/go"
RDEPEND=""

GO_PN="github.com/tools/${PN}"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"

export GOPATH="${S}"

src_prepare() {
	go get ${GO_PN}
}

src_compile() {
	go build -v -x -work ${GO_PN} || die
}

src_install() {
	dobin godep
#insinto /usr/lib/go/
#doins -r "${S}/pkg"
#insinto /usr/lib/go/src/pkg
#doins -r "${S}/src/."
}

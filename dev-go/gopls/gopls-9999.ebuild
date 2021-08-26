# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module git-r3

DESCRIPTION="official go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls"
EGIT_REPO_URI="https://github.com/golang/tools.git"

S="${WORKDIR}/${P}/${PN}"

RESTRICT="network-sandbox"
LICENSE="MIT"
SLOT="0"
IUSE=""

src_unpack() {
	default
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	go build -o ${PN} || die
}

src_install() {
	dobin ${PN}
}

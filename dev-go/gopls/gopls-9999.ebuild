# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="official go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls"
EGIT_REPO_URI="https://github.com/golang/tools.git"

S="${WORKDIR}/${P}/${PN}"

LICENSE="MIT"
SLOT="0"

src_unpack() {
	default
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build -o "${PN}"
}

src_install() {
	dobin "${PN}"
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="Top-like interface for container-metrics"
HOMEPAGE="https://ctop.sh https://github.com/bcicen/ctop"
EGIT_REPO_URI="https://github.com/bcicen/${PN}"
LICENSE="MIT"
SLOT="0"
IUSE="hardened"
# RESTRICT="test"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	ego build -ldflags "-X main.version=${PV} -X main.build=${EGIT_COMMIT:0:7}" -o "${PN}"
}

src_install() {
	dobin "${PN}"
	dodoc README.md
}

# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/nats-io/${PN}"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
EGIT_MIN_CLONE_TYPE="single+tags"
S="${EGIT_CHECKOUT_DIR}"
EGIT_REPO_URI="https://${EGO_PN}"

inherit golang-base git-r3

SRC_URI="${EGO_VENDOR_URI}"

DESCRIPTION="A high Performance NATS Server written in GoLang"
HOMEPAGE="https://nats.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

src_compile() {
	export GOPATH="${WORKDIR}/${P}"
	go build
}

src_install() {
	dobin "${PN}"
	dodoc README.md
}

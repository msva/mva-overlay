# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 systemd

DESCRIPTION="A high Performance NATS Server written in GoLang"
HOMEPAGE="https://nats.io"

EGIT_REPO_URI="https://github.com/nats-io/gnatsd"

LICENSE="MIT"
SLOT="0"

DOCS=( README.md conf/simple.conf )

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	GOARCH= ego build
}

src_install() {
	dobin nats-server
	einstalldocs
	systemd_dounit util/*.service
}

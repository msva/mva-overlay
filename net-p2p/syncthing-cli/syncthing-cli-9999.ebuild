# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils git-r3

DESCRIPTION="Open, trustworthy and decentralized sync engine (like DropBox/BTSync)"
HOMEPAGE="http://syncthing.net"

SRC_URI=""
EGIT_REPO_URI="https://github.com/syncthing/${PN}"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/go
	dev-go/godep
"
RDEPEND="${DEPEND}"

DOCS=( README.md LICENSE )

export GOPATH="${S}"

GO_PN="github.com/syncthing/${PN}"
EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"
S="${EGIT_CHECKOUT_DIR}"

src_compile() {
	# XXX: All the stuff below needs for "-version" command to show actual info
	local version="$(git describe --always | sed 's/\([v\.0-9]*\)\(-\(beta\|alpha\)[0-9]*\)\?-/\1\2+/')";
	local date="$(git show -s --format=%ct)";
	local user="$(whoami)"
	local host="$(hostname)"; host="${host%%.*}";
	local lf="-w -X main.Version ${version} -X main.BuildStamp ${date} -X main.BuildUser ${user} -X main.BuildHost ${host}"

	go get
	go build
}

src_install() {
	dobin syncthing-cli
	default
}

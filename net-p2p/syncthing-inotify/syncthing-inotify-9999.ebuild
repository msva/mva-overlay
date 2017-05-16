# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd git-r3

DESCRIPTION="Open, trustworthy and decentralized sync engine (like DropBox/BTSync)"
HOMEPAGE="http://syncthing.net"

SRC_URI=""
EGIT_REPO_URI="https://github.com/syncthing/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/go
	dev-go/godep
"
RDEPEND="${DEPEND}"

export GOPATH="${S}"

GO_PN="github.com/syncthing/${PN}"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${GO_PN}"
S="${EGIT_CHECKOUT_DIR}"

DOCS=( README.md LICENSE )

src_compile() {
	# XXX: All the stuff below needs for "-version" command to show actual info
	#local version="$(git describe --always | sed 's/\([v\.0-9]*\)\(-\(beta\|alpha\)[0-9]*\)\?-/\1\2+/')";
	local version="$(git describe --always)";
	local date="$(git show -s --format=%ct)";
	local user="$(whoami)"
	local host="$(hostname)"; host="${host%%.*}";
	local lf="-w -X main.Version ${version:-9999} -X main.BuildStamp ${date:-date is not set} -X main.BuildUser ${user:-portage} -X main.BuildHost ${host:-localhost}"

	go get
	go build -ldflags "${lf}"
}

src_install() {
	dobin "${GOPATH}/bin/syncthing-inotify"
	systemd_dounit "${S}/etc/linux-systemd/system/${PN}@.service"
	systemd_douserunit "${S}/etc/linux-systemd/user/${PN}.service"
	default
}

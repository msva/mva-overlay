# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils base systemd git-r3

DESCRIPTION="Open, trustworthy and decentralized syncing engine (some kind of analog of DropBox and BTSync)"
HOMEPAGE="http://syncthing.net"

SRC_URI=""
EGIT_REPO_URI="https://github.com/syncthing/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/go-1.5.1
	dev-go/godep
"

RDEPEND="${DEPEND}"

DOCS=( README.md AUTHORS LICENSE CONTRIBUTING.md )

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
	local lf="-w -X main.Version=${version} -X main.BuildStamp=${date} -X main.BuildUser=${user} -X main.BuildHost=${host}"

	godep go build -ldflags "${lf}" -tags noupgrade ./cmd/syncthing
}

src_install() {
	touch "${T}/${PN}.confd"
	dobin syncthing

	systemd_dounit "${S}/etc/linux-systemd/system/${PN}@.service"
	systemd_douserunit "${S}/etc/linux-systemd/user/${PN}.service"

	newinitd "${FILESDIR}/${PN}.init-r1" "${PN}"
	newconfd "${T}/${PN}.confd" "${PN}"

	base_src_install_docs
}

pkg_postinst() {
	elog "If you want to run Syncthing for more than one user, you can:"
	elog
	elog "In case you're using OpenRC:"
	elog "Create a symlink to the syncthing init script called"
	elog "syncthing.<username> - like so:"
	elog "\t# ln -s syncthing /etc/init.d/syncthing.johndoe"
	elog "and start/rc-update it instead of 'standard' one"
	elog
	elog "In case you're using SystemD:"
	elog "Just start (and 'enable', for autostarting) service like:"
	elog "\t# systemctl start ${PN}@johndoe"
	elog "instead of 'standard' one."
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 systemd

EGIT_REPO_URI="github.com/42wim/matterbridge"

DESCRIPTION="Bridge between multiple chat networks"
HOMEPAGE="https://github.com/42wim/matterbridge"

LICENSE="Apache-2.0"
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
	default

	newinitd "${FILESDIR}/${PN}.initd" matterbridge
	systemd_dounit "${FILESDIR}/${PN}.service"
	dobin matterbridge
	# fowners matterbridge:matterbridge /usr/bin/matterbridge || die "fowners failed"
}

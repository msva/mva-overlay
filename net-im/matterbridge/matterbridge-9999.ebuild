# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs systemd user

EGO_PN="github.com/42wim/matterbridge"

KEYWORDS=""

DESCRIPTION="Bridge between multiple chat networks"
HOMEPAGE="https://github.com/42wim/matterbridge"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.8:*"

pkg_setup() {
	enewgroup matterbridge
	enewuser matterbridge -1 -1 -1 matterbridge
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" matterbridge
	systemd_dounit "${FILESDIR}/${PN}.service"
	dobin matterbridge
	fowners matterbridge:matterbridge /usr/bin/matterbridge || die "fowners failed"
}

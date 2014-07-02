# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils user systemd git-r3

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

DESCRIPTION="DHT Bootstrap daemon for Tox IM network (useful for system administrators)"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="nacl test"

RDEPEND="
		net-libs/tox[nacl=]
"
DEPEND="${RDEPEND}"
AUTOTOOLS_AUTORECONF="yes"

pkg_setup() {
	enewgroup tox
	enewuser tox -1 -1 /var/lib/tox tox -m
}

src_prepare() {
	# Config fixes
	sed -r \
		-e 's#(keys_file_path).*#\1 = "/var/lib/tox/.daemon.keys"#' \
		-e 's#(pid_file_path).*#\1 = "/run/tox/tox-dht.pid"#' \
		-e 's#(tcp_relay_ports).*#\1 = [3389, 33445]#' \
		-i other/bootstrap_daemon/conf
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable test testing)
		$(use_enable nacl)
		--disable-ntox
		--enable-daemon
	)
	autotools-utils_src_configure
}

src_install() {
	echo '' >> "${T}"/confd
	newconfd "${T}"/confd "${PN}"
	newbin "${BUILD_DIR}"/build/.libs/tox_bootstrap_daemon tox_bootstrapd
	newinitd "${FILESDIR}/initd" "${PN}"
	systemd_newunit "${FILESDIR}"/systemd.unit "${PN}.service"
	insinto /etc/tox/
	newins other/bootstrap_daemon/conf DHT_bootstrap.cfg
}

pkg_postinst() {
	use nacl && (
		ewarn "Although NaCl-linked tox is faster in crypto-things, NaCl-build is"
		ewarn "not portable (you'll be unable to ship binary packages to another machine)."
	)

	ewarn "Don't forget to ask you local users to add your DHT node to their local DHTnodes list"
}

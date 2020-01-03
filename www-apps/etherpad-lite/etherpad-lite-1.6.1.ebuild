# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd
DESCRIPTION="A really-real time collaborative word processor for the web"
HOMEPAGE="http://etherpad.org"
SRC_URI="https://github.com/ether/etherpad-lite/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

RDEPEND="net-libs/nodejs"
DEPEND="${RDEPEND}"

ETHERPAD_DEST="/usr/share/${PN}"
ETHERPAD_LOG="/var/log/${PN}"
ETHERPAD_USER="etherpad"
ETHERPAD_GROUP="daemon"

pkg_setup() {
	enewgroup ${ETHERPAD_GROUP}
	enewuser ${ETHERPAD_USER} -1 -1 ${ETHERPAD_DEST} "${ETHERPAD_GROUP}"
}

src_prepare() {
	default
	./bin/installDeps.sh || die
}

src_install() {
	local etc="/etc/${PN}"
	insinto "${etc}"
	doins "settings.json"
	rm "settings.json"
	dosym "${etc}/settings.json" "${ETHERPAD_DEST}/settings.json"

	mkdir -p "${D}${ETHERPAD_DEST}"
	cp -a . "${D}${ETHERPAD_DEST}"

	keepdir "${ETHERPAD_LOG}"
	fowners "${ETHERPAD_USER}:${ETHERPAD_GROUP}" "${ETHERPAD_LOG}"

	newconfd "${FILESDIR}/${PN}-conf.d" "${PN}"
	newinitd "${FILESDIR}/${PN}-init.d" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}

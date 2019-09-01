# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user systemd

DESCRIPTION="The Prometheus monitoring system and time series database (Push Gateway)"
HOMEPAGE="http://prometheus.io"

MY_PN="${PN##prometheus-}"
MY_P="${P##prometheus-}"
EGO_PN="github.com/prometheus/${MY_PN}"

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/go-1.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

DAEMON_USER="prometheus"
LOG_DIR="/var/log/prometheus"
DATA_DIR="/var/lib/prometheus"

pkg_setup() {
	enewuser ${DAEMON_USER} -1 -1 "${DATA_DIR}"
}

src_unpack() {
	default
	mkdir -p "${P}/src/${EGO_PN%/*}"
	mv "${MY_P}" "${P}/src/${EGO_PN}"
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}"
	export PREFIX="${S}/${MY_PN}"
	emake build
}

src_install() {
	newbin "${MY_PN}" "${PN}"

	insinto /etc/prometheus

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/default
	newins "${FILESDIR}/${PN}.default" "${PN}"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"

	keepdir "${DATA_DIR}"
	fowners "${DAEMON_USER}" "${DATA_DIR}"
}

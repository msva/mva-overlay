# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user systemd

DESCRIPTION="The Prometheus monitoring system and time series database"
HOMEPAGE="http://prometheus.io"
EGO_PN="github.com/${PN}/${PN}"
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
	mkdir -p "temp/src/${EGO_PN%/*}"
	mv "${P}" "temp/src/${EGO_PN}"
	mv temp "${P}"
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}"
	emake build
}

src_install() {
	dobin "${PN}"
	dobin promtool

	insinto /etc/prometheus
	doins documentation/examples/prometheus.yml

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/default
	newins "${PN}.default" "${PN}"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"

	keepdir "${DATA_DIR}"
	fowners "${DAEMON_USER}" "${DATA_DIR}"
}

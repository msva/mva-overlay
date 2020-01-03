# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user systemd

MY_PN="${PN##prometheus-}"
EGO_PN="github.com/adhocteam/${MY_PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for custom scripts"
HOMEPAGE="https://github.com/adhocteam/script_exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.5
"

EXPORTER_USER=prometheus-exporter

MY_P="${P##prometheus-}"
S="${WORKDIR}/${MY_P}/src/${EGO_PN}"

pkg_setup() {
	enewuser "${EXPORTER_USER}" -1 -1 -1
}

src_unpack() {
	default
	mkdir -p "temp/src/${EGO_PN%/*}"
	mv "${MY_P}" "temp/src/${EGO_PN}"
	mv temp "${MY_P}"
}

src_compile() {
	export GOPATH="${WORKDIR}/${MY_P}"
	export PREFIX="${S}/${PN}"
	go get
	go build
}

src_install() {
	newbin "${MY_PN}" "${PN}"
	dodoc README.md

	keepdir /var/lib/prometheus/"${MY_PN}" /var/log/prometheus
	fowners "${EXPORTER_USER}" /var/lib/prometheus/"${MY_PN}" /var/log/prometheus

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/default
	newins "${FILESDIR}/${PN}.default" "${PN}"
}

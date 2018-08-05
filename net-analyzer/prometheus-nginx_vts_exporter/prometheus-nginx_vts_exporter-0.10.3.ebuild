# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user systemd

MY_PN="${PN##prometheus-}"
MY_PN="${MY_PN//_/-}"
EGO_PN="github.com/hnlq715/${MY_PN}"
COMMIT="c894c71"
#SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://${EGO_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for NginX vts stats"
HOMEPAGE="https://github.com/hnlq715/nginx-vts-exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.5"

EXPORTER_USER=prometheus-exporter

MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}/src/${EGO_PN}"

pkg_setup() {
	enewuser "${EXPORTER_USER}" -1 -1 -1
}

src_unpack() {
	default
	mkdir -p "temp/src/${EGO_PN%/*}"
	#mv "${MY_P}" "temp/src/${EGO_PN}"
	mv "${MY_PN}-${COMMIT}"* "temp/src/${EGO_PN}"
	mv temp "${MY_P}"
}

src_compile() {
	export GOPATH="${WORKDIR}/${MY_P}"
	export PREFIX="${S}/${PN}"
	emake build
}

src_install() {
	dobin "${PN}/${MY_PN}"
	dodoc README.md

	keepdir /var/lib/prometheus/"${MY_PN}" /var/log/prometheus
	fowners "${EXPORTER_USER}" /var/lib/prometheus/"${MY_PN}" /var/log/prometheus

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/default
	newins "${FILESDIR}/${PN}.default" "${PN}"
}

pkg_postinst() {
	einfo "This package requires www-servers/nginx[nginx_modules_http_vhost_traffic_status] for it's work (althoughm it can be installed on another instance)"
}

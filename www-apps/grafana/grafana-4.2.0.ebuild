# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user eutils versionator systemd pax-utils

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
EGO_PN="github.com/${PN}/${PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	www-client/phantomjs
	net-libs/nodejs
"
DEPEND="
	${RDEPEND}
	>=dev-lang/go-1.5
	!www-apps/grafana-plugins-prometheus
	sys-apps/yarn
"

S="${WORKDIR}/${P}/src/${EGO_PN}"

DAEMON_USER="grafana"
LOG_DIR="/var/log/grafana"
DATA_DIR="/var/lib/grafana"

if [[ -d "${FILESDIR}/patches/${PV}" ]]; then
	PATCHES=("${FILESDIR}/patches/${PV}")
fi

pkg_setup() {
	enewuser ${DAEMON_USER} -1 -1 "${DATA_DIR}"
}

src_unpack() {
	default
	mkdir -p temp/src/${EGO_PN%/*} || die
	mv ${P} temp/src/${EGO_PN} || die
	mv temp ${P} || die

	cd "${S}"
	npm install node-sass
	npm install grunt-cli
	emake deps-go deps-js
	cd -
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}"
	export PATH="${PATH}:${WORKDIR}/${P}/bin"
	emake
}

src_install() {
	insinto "/usr/share/${PN}"
	if [[ -e vendor/phantomjs/phantomjs ]]; then
		rm vendor/phantomjs/phantomjs;
		dosym /usr/bin/phantomjs vendor/phantomjs/phantomjs;
	fi
	doins -r conf vendor

	insinto "/usr/share/${PN}/public"
	doins -r public_gen/*

	# Disable MPROTECT to run in hardened kernels
	dobin bin/"${PN}"-server
	host-is-pax && pax-mark m "${ED}usr/bin/${PN}"-server

	newconfd "${FILESDIR}/${PN}".confd "${PN}"
	newinitd "${FILESDIR}/${PN}".initd "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/"${PN}"
	insinto /etc/"${PN}"
	doins "${FILESDIR}/${PN}".ini

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"
	fperms 0750 "${LOG_DIR}"

	keepdir "${DATA_DIR}"
	fowners "${DAEMON_USER}" "${DATA_DIR}"
	fperms 0750 "${DATA_DIR}"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base user eutils systemd pax-utils patches

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
EGO_PN="github.com/${PN}/${PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-libs/nodejs
"
#	www-client/phantomjs
# banned in gentoo ^^^

DEPEND="
	${RDEPEND}
	>=dev-lang/go-1.8
	!www-apps/grafana-plugins-prometheus
	>=sys-apps/yarn-0.22.0
"

S="${WORKDIR}/${P}/src/${EGO_PN}"

DAEMON_USER="grafana"
LOG_DIR="/var/log/grafana"
DATA_DIR="/var/lib/grafana"

QA_PREBUILT="usr/share/${PN}/vendor/phantomjs/phantomjs"

pkg_setup() {
	ewarn "Unfortunatelly, PhantomJS upstream has discontinued it's development."
	ewarn "So as Gentoo stopped it's maintenance due to many security issues and bugs"
	ewarn "While ${PN} still uses it for internal purposes."
	ewarn "That's why we don't strip 'bundled' copy of PhantomJS from ${PN} install dir."
	ewarn "So, be noticed, that while you're using ${PN}, you've potential security breach as PhantomJS"

	enewuser ${DAEMON_USER} -1 -1 "${DATA_DIR}"
}

src_unpack() {
	patches_src_prepare
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
	local PD="/usr/share/${PN}"
#	rm vendor/phantomjs/phantomjs;
	insinto "${PD}"
	doins -r conf vendor
#	dosym /usr/bin/phantomjs "${PD}"/vendor/phantomjs/phantomjs;

	insinto "${PD}/public"
	doins -r public_gen/*

	# Disable MPROTECT to run in hardened kernels
	dobin bin/"${PN}"-server
	host-is-pax && pax-mark m "${ED}usr/bin/${PN}"-server
	host-is-pax && pax-mark m "${ED}${PD}/vendor/bin/phantomjs"

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

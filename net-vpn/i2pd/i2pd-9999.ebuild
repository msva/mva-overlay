# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit pax-utils systemd git-r3 cmake

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
EGIT_REPO_URI="https://github.com/PurpleI2P/i2pd"
EGIT_BRANCH="openssl"
LICENSE="BSD"
SLOT="0"
IUSE="cpu_flags_x86_aes i2p-hardening thread-sanitizer addr-sanitizer +upnp"

RDEPEND="
	acct-user/i2pd
	acct-group/i2pd
	dev-libs/boost[threads(+)]
	dev-libs/openssl
	upnp? ( net-libs/miniupnpc )
"
DEPEND="${RDEPEND}"

CMAKE_USE_DIR="${S}/build"

DOCS=( README.md contrib/{i2pd,tunnels}.conf )

PATCHES=( "${FILESDIR}/patches/${PV}" )
# ^ for cmake

src_configure() {
	mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
		-DWITH_STATIC=OFF # no more static boost and miniupnpc
		-DWITH_UPNP=$(usex upnp ON OFF)
		-DWITH_LIBRARY=ON
		-DWITH_BINARY=ON
		-DWITH_ADDRSANITIZER=$(usex addr-sanitizer ON OFF)
		-DWITH_THREADSANITIZER=$(usex thread-sanitizer ON OFF)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	einstalldocs

	# config
	insinto /etc/"${PN}"
	doins contrib/"${PN}".conf
	doins contrib/tunnels.conf

	# grant i2pd group read and write access to config files
	fowners "root:${I2PD_GROUP}" \
		/etc/"${PN}"/"${PN}".conf \
		/etc/"${PN}"/tunnels.conf
	fperms 660 \
		/etc/"${PN}"/"${PN}".conf \
		/etc/"${PN}"/tunnels.conf

	# working directory
	insinto /var/lib/"${PN}"
	doins -r contrib/certificates
	fowners i2pd:i2pd /var/lib/"${PN}"
	fperms 700 /var/lib/"${PN}"

	# add /var/lib/i2pd/certificates to CONFIG_PROTECT
	doenvd "${FILESDIR}/99i2pd"

	# openrc and systemd daemon routines
	newconfd "${FILESDIR}/${PN}".confd "${PN}"
	newinitd "${FILESDIR}/${PN}".initd "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	doman "debian/${PN}.1"

	host-is-pax && pax-mark m "${ED}/usr/bin/${PN}"
}

pkg_postinst() {
	if [[ -f ${EROOT}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}

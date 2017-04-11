# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils systemd pax-utils user git-r3 cmake-utils
# multilib-minimal

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
EGIT_REPO_URI="https://github.com/PurpleI2P/i2pd"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_aes cjdns i2lua i2p-hardening libressl pch thread-sanitizer addr-sanitizer static +upnp websockets"
#api daemon
RDEPEND="
	!static? (
		>=dev-libs/boost-1.49[threads]
		!libressl? ( dev-libs/openssl:0[-bindist] )
		libressl? ( dev-libs/libressl )
		upnp? ( net-libs/miniupnpc )
	)
"
DEPEND="
	${RDEPEND}
	static? (
		>=dev-libs/boost-1.49[static-libs,threads]
		!libressl? ( dev-libs/openssl:0[static-libs] )
		libressl? ( dev-libs/libressl[static-libs] )
		upnp? ( net-libs/miniupnpc[static-libs] )
	)
	i2p-hardening? ( >=sys-devel/gcc-4.7 )
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.3 )
"

I2PD_USER="${I2PD_USER:-i2pd}"
I2PD_GROUP="${I2PD_GROUP:-i2pd}"

CMAKE_USE_DIR="${S}/build"

DOCS=( README.md contrib/{i2pd,tunnels}.conf )

#		echo 'LDFLAGS="-Wl,-soname,$@"' >> .config
#	use api && myemakeargs+=("api_client" "api")
#		dolib.so libi2pd{,client}.so
#		use static && dolib.a libi2pd{,client}.a

PATCHES=( "${FILESDIR}/${PN}-2.5.1-fix_installed_components.patch" )

src_configure() {
	mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
		-DWITH_PCH=$(usex pch ON OFF)
		-DWITH_STATIC=$(usex static ON OFF)
		-DWITH_UPNP=$(usex upnp ON OFF)
		-DWITH_LIBRARY=ON
		-DWITH_BINARY=ON
		-DWITH_MESHNET=$(usex cjdns ON OFF)
		-DWITH_ADDRSANITIZER=$(usex addr-sanitizer ON OFF)
		-DWITH_THREADSANITIZER=$(usex thread-sanitizer ON OFF)
		-DWITH_I2LUA=$(usex i2lua ON OFF)
		-DWITH_WEBSOCKETS=$(usex websockets ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

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
	keepdir /var/lib/"${PN}"
	insinto /var/lib/"${PN}"
	doins -r contrib/certificates
	fowners "${I2PD_USER}:${I2PD_GROUP}" /var/lib/"${PN}"
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
	host-is-pax && pax-mark m "${ED}usr/bin/${PN}"
}

pkg_setup() {
	enewgroup "${I2PD_GROUP}"
	enewuser "${I2PD_USER}" -1 -1 "/var/lib/run/${PN}" "${I2PD_GROUP}"
}

pkg_postinst() {
	if [[ -f ${EROOT%/}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit pax-utils systemd git-r3 qmake-utils cmake
# multilib-minimal

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
EGIT_REPO_URI="https://github.com/PurpleI2P/i2pd"
EGIT_BRANCH="openssl"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_aes cpu_flags_x86_avx cjdns i2lua i2p-hardening libressl pch thread-sanitizer addr-sanitizer static +upnp websockets gui"

#api daemon

REQUIRED_USE="gui? ( !cjdns !i2lua !i2p-hardening !thread-sanitizer !addr-sanitizer !static !pch upnp websockets )"

RDEPEND="
	acct-user/i2pd
	acct-group/i2pd
	!static? (
		>=dev-libs/boost-1.49[threads(+)]
		!libressl? ( dev-libs/openssl:0[-bindist] )
		libressl? ( dev-libs/libressl )
		upnp? ( net-libs/miniupnpc )
	)
	gui? (
		net-libs/miniupnpc
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	websockets? (
		dev-cpp/websocketpp
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

PATCHES=( "${FILESDIR}/patches/${PV}" )
# ^ for cmake

src_configure() {
	if use gui; then
		cd qt/"${PN}"_qt;
		eqmake5
	else
		mycmakeargs=(
			-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
			-DWITH_AVX=$(usex cpu_flags_x86_avx ON OFF)
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
		cmake_src_configure
	fi
}

src_compile() {
	if use gui; then
		emake -C qt/"${PN}"_qt;
	else
#		emake USE_AESNI=$(usex cpu_flags_x86_aes) USE_AVX=$(usex cpu_flags_x86_avx) USE_STATIC=$(usex static) USE_MESHNET=$(usex cjdns) USE_UPNP=$(usex upnp)
		# ^ in case of activation of no-cmake buildsystem
		cmake_src_compile
	fi
}

src_install() {
	if use gui; then
		emake -C qt/"${PN}"_qt install
		newbin "qt/${PN}_qt/${PN}_qt" "${PN}"
		insinto /usr/include/"${PN}"
		doins {daemon,libi2pd{,_client}}/*.h
	else
		cmake_src_install
#		dobin "${PN}"
#		insinto /usr/include/"${PN}"
#		doins {daemon,libi2pd{,_client}}/*.h
	fi

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

	if ! use gui; then
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
	fi

	doman "debian/${PN}.1"

	host-is-pax && pax-mark m "${ED}usr/bin/${PN}"
}

pkg_postinst() {
	if use gui; then
		ewarn
		ewarn "You've enabled 'gui' USE-flag. This means, you've installed GUI-ONLY version of ${PN}"
		ewarn "Actually, currently it is pretty useless (it has only tray icon and two 'quit' buttons (force and graceful)"
	fi
	if [[ -f ${EROOT%/}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}

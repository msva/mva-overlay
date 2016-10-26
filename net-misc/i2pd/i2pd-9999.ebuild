# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils systemd pax-utils user git-r3 multilib-minimal

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PurpleI2P/i2pd"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="api +daemon static upnp"

RDEPEND="
	!static? (
		>=dev-libs/boost-1.46[threads]
		dev-libs/crypto++
	)
"
DEPEND="
	${RDEPEND}
	static? (
		>=dev-libs/boost-1.46[static-libs,threads]
		dev-libs/crypto++[static-libs]
	)
	upnp? ( >=net-libs/miniupnpc-1.5 )
	|| ( >=sys-devel/gcc-4.6 >=sys-devel/clang-3.3 )
"

I2PD_USER="${I2PD_USER:-i2pd}"
I2PD_GROUP="${I2PD_GROUP:-i2pd}"

REQUIRED_USE="|| ( daemon api )"

src_prepare() {
	# support for custom configuration
	sed -i \
		-e "1iinclude .config" \
		-e "s/:=/?=/g" \
		 Makefile
	touch .config

	# Fix expr syntax error on multilib builds
	sed -i -r \
		-e '/expr match/s@(\$\(CXX\))@"\1"@' \
		Makefile.linux

	multilib_copy_sources
}

multilib_src_configure() {
	use static && echo USE_STATIC=yes >> .config
	use upnp && echo USE_UPNP=1 >> .config

	use api && (
		# Fix QA warning about missing SONAME
		echo 'LDFLAGS="-Wl,-soname,$@"' >> .config
	)
}

multilib_src_compile() {
	local myemakeargs=("deps");
	use api && myemakeargs+=("api_client" "api")
	use daemon && multilib_is_native_abi && myemakeargs+=("i2pd")

	# skip multilib build if we have nothing to build
	! use api && ! multilib_is_native_abi && return

	emake "${myemakeargs[@]}"
}

multilib_src_install() {
	use daemon && multilib_is_native_abi && dobin i2pd
	use api && (
		dolib.so libi2pd{,client}.so
		use static && dolib.a libi2pd{,client}.a
	)
}

multilib_src_install_all() {
	dodoc README.md
	doman "${FILESDIR}/${PN}.1"
	keepdir /var/lib/i2pd/
	fowners "${I2PD_USER}:${I2PD_GROUP}" /var/lib/i2pd/
	fperms 700 /var/lib/i2pd/
	insinto /etc/
	doins "${FILESDIR}/${PN}.conf"
	fowners "${I2PD_USER}:${I2PD_GROUP}" "/etc/${PN}.conf"
	fperms 600 "/etc/${PN}.conf"
	dodir /usr/share/i2pd
	cp -R "${S}/contrib/certificates" "${D}/var/lib/i2pd" || die "Install failed!"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	doenvd "${FILESDIR}/99${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	host-is-pax && pax-mark m "${ED}usr/sbin/${PN}"
}

pkg_setup() {
	enewgroup "${I2PD_GROUP}"
	enewuser "${I2PD_USER}" -1 -1 "/var/lib/run/${PN}" "${I2PD_GROUP}"
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd tmpfiles git-r3

DESCRIPTION="An open source instant messaging transport"
HOMEPAGE="https://spectrum.im"

EGIT_REPO_URI="https://github.com/SpectrumIM/spectrum2"

LICENSE="GPL-2+"
SLOT="0"

IUSE_PLUGINS="frotz irc purple skype sms twitter whatsapp xmpp"
IUSE="debug doc mysql postgres sqlite test ${IUSE_PLUGINS}"

RDEPEND="
	acct-user/spectrum
	acct-group/spectrum
	dev-libs/boost:=[nls]
	dev-libs/expat
	dev-libs/libev:=
	dev-libs/log4cxx
	dev-libs/jsoncpp:=
	dev-libs/openssl:0=
	dev-libs/popt
	dev-libs/protobuf:=
	net-dns/libidn:0=
	net-im/swift:=
	net-misc/curl
	sys-libs/zlib:=
	frotz? ( !games-engines/frotz )
	irc? ( net-im/libcommuni )
	mysql? (
		|| (
			dev-db/mariadb-connector-c
			dev-db/mysql-connector-c
		)
	)
	postgres? ( dev-libs/libpqxx:= )
	purple? (
		dev-libs/glib
		net-im/pidgin:=
	)
	sms? ( app-mobilephone/smstools )
	sqlite? ( dev-db/sqlite:3 )
	skype? ( x11-plugins/pidgin-skypeweb )
	twitter? ( net-misc/curl )
	whatsapp? ( net-im/transwhat )
"
# TODO:
#      1) write native telegram transport in transwhat way
#      2) add it here

DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	doc? ( app-text/doxygen )
	test? ( dev-util/cppunit )
"

REQUIRED_USE="|| ( sqlite mysql postgres ) test? ( irc )"
RESTRICT="!test? ( test )"

src_prepare() {
	# Respect users LDFLAGS
	sed -i -e "s/-Wl,-export-dynamic/& ${LDFLAGS}/" spectrum/src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS="$(usex doc)"
		-DENABLE_FROTZ="$(usex frotz)"
		-DENABLE_IRC="$(usex irc)"
		-DENABLE_MYSQL="$(usex mysql)"
		-DENABLE_PQXX="$(usex postgres)"
		-DENABLE_PURPLE="$(usex purple)"
		$(usex irc '-DENABLE_QT4=OFF' '')
		-DENABLE_SMSTOOLS3="$(usex sms)"
		-DENABLE_SQLITE3="$(usex sqlite)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_TWITTER="$(usex twitter)"
		-DENABLE_XMPP="$(usex xmpp)"
		-DLIB_INSTALL_DIR="$(get_libdir)"
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/tests/libtransport" || die
	./libtransport_test || die
}

src_install() {
	cmake_src_install

	diropts -o spectrum -g spectrum
	keepdir /var/log/spectrum2 /var/lib/spectrum2
	diropts

	# TODO: test on prefix
	newinitd "${FILESDIR}"/spectrum2.initd spectrum2
	systemd_newunit "${FILESDIR}"/spectrum2.service spectrum2.service
	systemd_newtmpfilesd "${FILESDIR}"/spectrum2.tmpfiles-r1 spectrum2.conf

	einstalldocs
}

pkg_postinst() {
	tmpfiles_process spectrum2.conf
}

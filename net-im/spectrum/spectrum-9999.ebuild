# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-r3"

inherit cmake-utils ${VCS_ECLASS}

DESCRIPTION="Spectrum is an XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

if [[ ${PV} == *9999* ]]; then
#EGIT_REPO_URI="git://github.com/hanzz/libtransport.git"
	EGIT_REPO_URI="https://github.com/hanzz/spectrum2"
#  EGIT_BRANCH="swiften3"
else
#  MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/downloads/hanzz/spectrum2/spectrum-2.0.0-beta2.tar.gz"
#  S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE_PLUGINS="frotz irc purple skype smstools twitter"
IUSE="debug doc libev mysql postgres sqlite staticport symlinks test tools ${IUSE_PLUGINS}"

RDEPEND="
	net-im/jabber-base
	dev-libs/boost:*
	net-im/swiften
	dev-libs/popt
	dev-libs/openssl:0
	dev-libs/log4cxx
	mysql? ( virtual/mysql )
	postgres? ( dev-libs/libpqxx )
	sqlite? ( dev-db/sqlite:3 )
	frotz? ( dev-libs/protobuf )
	irc? ( net-im/libcommuni[qt4] dev-libs/protobuf )
	purple? ( >=net-im/pidgin-2.6.0 dev-libs/protobuf )
	skype? ( x11-plugins/pidgin-skypeweb dev-libs/protobuf )
	libev? ( dev-libs/libev dev-libs/protobuf )
"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/cmake
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
	"

REQUIRED_USE="|| ( sqlite mysql postgres )"

PROTOCOL_LIST="aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo"

pkg_setup() {
	CMAKE_IN_SOURCE_BUILD=1
	use debug && CMAKE_BUILD_TYPE=Debug
	MYCMAKEARGS="-DLIB_INSTALL_DIR=$(get_libdir)"
}

src_prepare() {
	use sqlite || { sed -i -e 's/find_package(sqlite3)/set(SQLITE3_FOUND FALSE)/' CMakeLists.txt || die; }
	use mysql || { sed -i -e 's/find_package(mysql)/set(MYSQL_FOUND FALSE)/' CMakeLists.txt || die; }
	use postgres || { sed -i -e 's/find_package(pqxx)/set(PQXX_FOUND FALSE)/' CMakeLists.txt || die; }
	use test || { sed -i -e 's/find_package(cppunit)/set(CPPUNIT_FOUND FALSE)/' CMakeLists.txt || die; }
	use doc || { sed -i -e 's/find_package(Doxygen)/set(DOXYGEN_FOUND FALSE)/' CMakeLists.txt || die; }
	use purple || { sed -i -e '/find_package(purple)/d' CMakeLists.txt || die; }
	use libev || { sed -i -e 's/find_package(event)/set(HAVE_EVENT FALSE)/' CMakeLists.txt || die; }
	use irc || { sed -i -e 's/find_package(Communi)/set(IRC_FOUND, FALSE)/' CMakeLists.txt || die; }

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	sed \
		-e "s:EPREFIX:${EPREFIX}:" \
		"${FILESDIR}"/spectrum.initd > "${WORKDIR}/initd"
	newinitd "${WORKDIR}/initd" spectrum
	keepdir "${EPREFIX}"/var/lib/spectrum2
	keepdir "${EPREFIX}"/var/log/spectrum2
}

pkg_postinst() {
	# Set correct rights
	chown jabber:jabber -R "/etc/spectrum2"
	chown jabber:jabber "${EPREFIX}"/var/lib/spectrum2
	chown jabber:jabber "${EPREFIX}"/var/log/spectrum2
}

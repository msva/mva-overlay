# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3
# multilib-minimal

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://github.com/analogdevicesinc/libiio"
EGIT_REPO_URI="https://github.com/analogdevicesinc/libiio"
EGIT_SUBMODULES=( "*" "-deps/wingetopt" )

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc examples ipv6 +xml"

RDEPEND="
	dev-libs/libxml2
	virtual/libusb:1
	dev-libs/libserialport
	net-dns/avahi
	examples? (
		sys-libs/ncurses:*
		dev-libs/cdk
	)
"
# TODO: examples? ( python, mono, ... )
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_prepare() {
	sed -r \
		-e "/^set\(CMAKE_INSTALL_DOCDIR/s@doc/[\$]\{PROJECT_NAME\}[\$]\{LIBIIO_VERSION_MAJOR\}-doc@doc/${PF:-9999}@g" \
		-i "${S}/CMakeLists.txt"
	use examples && (
		sed -r \
			-e '/#include <cdk\/cdk.h>/s@cdk/@@' \
			-i "${S}/examples/iio-monitor.c"
		sed -r \
			-e '/^iio-monitor:/{N;s@(-lncurses)([^[:alnum:]]?)@\1w -ltinfow\2@;s@(-lcdk)([^[:alnum:]]?)@\1w\2@}' \
			-i "${S}/examples/Makefile"
	)
	cmake_src_prepare
#	multilib_copy_sources
}

#multilib_src_configure() {
src_configure() {
	local mycmakeargs=(
		-DENABLE_IPV6=$(usex ipv6 ON OFF)
		-DWITH_NETWORK_GET_BUFFER=ON
		-DWITH_XML_BACKEND=$(usex xml ON OFF)
		-DWITH_DOC=$(usex doc ON OFF)
		-DWITH_TESTS=OFF
		-DWITH_SYSTEMD=ON
#		-DWITH_LOCAL_CONFIG=ON # libini (?)
#		-DWITH_SYSVINIT=ON # not OpenRC compatible
	)
	cmake_src_configure
}

#multilib_src_compile() {
src_compile() {
	cmake_src_compile
	use examples && {
		emake -C examples
	}
}

#multilib_src_install() {
src_install() {
	cmake_src_install

	use doc && {
		HTML_DOCS=( "${BUILD_DIR}/html/" )
	}

	use examples && (
		dobin examples/{iio-monitor,{dummy,ad93{6,7}1}-iiostream}
	)
}

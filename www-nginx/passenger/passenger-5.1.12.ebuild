# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"
RUBY_OPTIONAL="yes"

NG_MOD_LIST=("ngx_http_passenger_module.so")
NG_MOD_SUFFIX="/src/nginx_module"

inherit ruby-ng nginx-module

DESCRIPTION="Phusion Passenger dynamic module for NginX"
HOMEPAGE="http://phusionpassenger.com/ https://github.com/phusion/passenger/"

SRC_URI="http://s3.amazonaws.com/phusion-passenger/releases/${P}.tar.gz"
# Enterprise: https://download:${PASSENGER_ENTERPRISE_DOWNLOAD_KEY}@www.phusionpassenger.com/orders/download?dir=${PV}&file=passenger-enterprise-server-${PV}.tar.gz -> ${P}.tar.gz

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug"

DEPEND="
	${CDEPEND}
	$(ruby_implementations_depend)
	>=dev-ruby/rake-0.8.1
	dev-libs/libev
	dev-libs/libuv
	!!www-apache/passenger
	!!www-nginx/passenger-enterprise
"
# TODO: try to unbundle jsoncpp

RDEPEND="${DEPEND}"

PASSENGER_WD="${WORKDIR}/all"

nginx-module-setup() {
	use debug && append-flags -DPASSENGER_DEBUG

### QA
#	append-cflags "-fno-strict-aliasing -Wno-unused-result -Wno-unused-variable"
#	append-cxxflags "-fno-strict-aliasing -Wno-unused-result -Wno-unused-variable"
### /QA

	ruby-ng_pkg_setup
}

nginx-module-unpack() {
	default
	mv "${WORKDIR}/${P}" "${PASSENGER_WD}"
	ln -s "${PASSENGER_WD}" "${WORKDIR}/${P}"
}

src_prepare() {
	pushd "${PASSENGER_WD}" &>/dev/null
	patches_src_prepare
	sed -r \
		-e "s:/buildout(/support-binaries):\1:" \
		-i src/cxx_supportlib/ResourceLocator.h

	sed \
		-e '/passenger-install-apache2-module/d' \
		-e "/passenger-install-nginx-module/d" \
		-i src/ruby_supportlib/phusion_passenger/packaging.rb

	sed -r \
		-e 's#(LIBEV_CFLAGS =).*#\1 "-I/usr/include"#' \
		-e 's#(LIBUV_CFLAGS =).*#\1 "-I/usr/include"#' \
		-i build/common_library.rb

	sed \
		-e 's#local/include#include#' \
		-i src/ruby_supportlib/phusion_passenger/platform_info/cxx_portability.rb

############################################################
## WARNING! That code trying to unpatch passenger from it's bundled libev
## May provide crashes at runtime! If this is a case why you're looking here
## then report that issue in overlay issue tracker, please.
##
## Also you can participate here: http://git.io/vL2In
############################################################
	sed \
		-e '/ev_loop_get_pipe/d' \
		-e '/ev_backend_fd/d' \
		-i src/cxx_supportlib/SafeLibev.h src/cxx_supportlib/BackgroundEventLoop.cpp
############################################################

	rm  -r \
		bin/passenger-install-apache2-module \
		bin/passenger-install-nginx-module \
		src/apache2_module \
		src/cxx_supportlib/vendor-copy/libuv \
		src/cxx_supportlib/vendor-modified/libev

	_PHASE="source copy" _ruby_each_implementation _ruby_source_copy

	export USE_VENDORED_LIBEV=no USE_VENDORED_LIBUV=no
	popd &>/dev/null
}

each_ruby_configure() {
	einfo "Precompiling support library for ${_ruby_implementation}"
	"${RUBY}" -S rake native_support || die "Premaking support lib failed!"
}

nginx-module-configure() {
	ruby-ng_src_configure
	einfo "Compiling Passenger support files"

	pushd "${PASSENGER_WD}" &>/dev/null
		export USE_VENDORED_LIBEV=no USE_VENDORED_LIBUV=no
		"${RUBY:-ruby}" -S rake nginx_dynamic_without_native_support || die "Passenger premake failed!"
	popd &>/dev/null

	einfo "Configuring NginX (to build the module)"

	myconf+=("--with-http_ssl_module")
}

passenger-install() {
	# dirty kludge to make passenger installation each-ruby compatible
	pushd "${NG_MOD_WD}" &>/dev/null
	"${RUBY}" -S rake fakeroot \
		NATIVE_PACKAGING_METHOD=ebuild \
		FS_PREFIX="${PREFIX}/usr" \
		FS_DATADIR="${PREFIX}/usr/libexec" \
		FS_DOCDIR="${PREFIX}/usr/share/doc/${P}" \
		FS_LIBDIR="${PREFIX}/usr/$(get_libdir)" \
		RUBYLIBDIR="$(ruby_rbconfig_value 'archdir')" \
		RUBYARCHDIR="$(ruby_rbconfig_value 'archdir')" \
	|| die "Passenger installation for ${RUBY} failed!"
	popd &>/dev/null
}

nginx-module-install() {
	_ruby_each_implementation passenger-install
}

nginx-module-postinst() {
	ewarn "Please, keep notice, that 'passenger_root' directive shall point to"
	ewarn "exact location of 'locations.ini' file from this package."
	ewarn "(It should be full path, including 'locations.ini' itself!)"
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit git-r3 user cmake-utils eutils

EGIT_REPO_URI="https://github.com/facebook/hhvm.git"
EGIT_BRANCH="master"

IUSE="+jemalloc devel debug"

CURL_P="curl-7.31.0"
LIBEVENT_P="libevent-1.4.14b-stable"

SRC_URI="
	http://curl.haxx.se/download/${CURL_P}.tar.bz2
	https://github.com/downloads/libevent/libevent/${LIBEVENT_P}.tar.gz
"

DESCRIPTION="Virtual Machine, Runtime, and JIT for PHP"
HOMEPAGE="https://github.com/facebook/hhvm"

RDEPEND="
	>=dev-libs/boost-1.49
	sys-devel/flex
	sys-devel/bison
	dev-util/re2c
	virtual/mysql
	dev-libs/libxml2
	dev-libs/libmcrypt
	dev-libs/icu
	dev-libs/openssl
	sys-libs/libcap
	media-libs/gd
	sys-libs/zlib
	dev-cpp/tbb
	dev-libs/oniguruma
	dev-libs/libpcre
	dev-libs/expat
	|| (
		sys-libs/readline
		dev-libs/libedit
	)
	sys-libs/ncurses
	dev-libs/libmemcached
	net-nds/openldap
	net-libs/c-client[kerberos]
	dev-util/google-perftools
	dev-libs/cloog
	dev-libs/elfutils
	=dev-libs/libdwarf-20120410
	app-arch/bzip2
	sys-devel/binutils
	>=sys-devel/gcc-4.7
	dev-cpp/glog
	jemalloc? ( >=dev-libs/jemalloc-3.0.0[stats] )
	dev-libs/libxslt
	media-gfx/imagemagick
"
#	net-misc/curl	
#	media-libs/libvpx
#	dev-libs/libevent

DEPEND="
	${RDEPEND}
	>=dev-util/cmake-2.8.7
"

SLOT="0"
LICENSE="PHP-3"
KEYWORDS="~amd64"

CMAKE_IN_SOURCE_BUILD="yes"

pkg_setup() {
	ebegin "Creating hhvm user and group"
	enewgroup hhvm
	enewuser hhvm -1 -1 "/var/lib/hhvm" hhvm
	eend $?
}


src_unpack() {
	git-r3_src_unpack
	unpack ${A}
}

src_prepare() {
	epatch "${FILESDIR}/support-curl-7.31.0.patch"

	export CMAKE_PREFIX_PATH="${D}/usr/lib/hhvm"

	einfo "Building custom libevent"
	export EPATCH_SOURCE="${S}/hphp/third_party"
	EPATCH_OPTS="-d ""${WORKDIR}/${LIBEVENT_P}" epatch libevent-1.4.14.fb-changes.diff
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	./autogen.sh
	./configure --prefix="${CMAKE_PREFIX_PATH}"
	emake
	emake -j1 install
	popd > /dev/null

	einfo "Building custom curl"
	EPATCH_OPTS="-d ""${WORKDIR}/${CURL_P} -p1" epatch libcurl.fb-changes.diff
	pushd "${WORKDIR}/${CURL_P}" > /dev/null
	./buildconf
	./configure --prefix="${CMAKE_PREFIX_PATH}"
	emake
	emake -j1 install
	popd > /dev/null
}

src_configure() {
	local CMAKE_BUILD_TYPE="Release"
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi
	export HPHP_HOME="${S}"
        mycmakeargs=(
		-DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
        )
        cmake-utils_src_configure
}

src_install() {
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	emake -j1 install
	popd > /dev/null

	pushd "${WORKDIR}/${CURL_P}" > /dev/null
	emake -j1 install
	popd > /dev/null

	rm -rf "${D}/usr/lib/hhvm/"{bin,include,share}
	rm -rf "${D}/usr/lib/hhvm/lib/pkgconfig"
	rm -f "${D}/usr/lib/hhvm/lib/"*.{a,la}

	exeinto "/usr/lib/hhvm/bin"
	doexe hphp/hhvm/hhvm

	if use devel; then
		cp -a "${S}/hphp/test" "${D}/usr/lib/hhvm/"
	fi

	dobin "${FILESDIR}/hhvm"
	newinitd "${FILESDIR}"/hhvm.initd hhvm
	newconfd "${FILESDIR}"/hhvm.confd hhvm
	dodir "/etc/hhvm"
	insinto /etc/hhvm
	newins "${FILESDIR}"/config.hdf.dist config.hdf.dist
}

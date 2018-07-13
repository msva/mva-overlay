# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit scons-utils toolchain-funcs multilib git-r3

DESCRIPTION="Library for implementing XMPP applications."
HOMEPAGE="http://swift.im/"
SRC_URI=""
EGIT_REPO_URI="git://swift.im/swift"
EGIT_BRANCH="swift-3.x"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="avahi expat gconf icu luajit test upnp"

RDEPEND="
	dev-libs/boost:=
	dev-libs/openssl:0
	net-dns/libidn:0
	sys-libs/zlib
	avahi? ( net-dns/avahi )
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	gconf? ( gnome-base/gconf dev-libs/glib:2 )
	luajit? ( || ( dev-lang/luajit:2 virtual/lua[luajit] ) )
	!luajit? ( dev-lang/lua:* )
	icu? ( dev-libs/icu:= )
	upnp? ( net-libs/libnatpmp net-libs/miniupnpc:= )
"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${PN}-libdir-${PV}.patch"

src_prepare() {
	# remove all bundled packages to ensure
	# consistency of headers and linked libraries
	rm -rf 3rdparty

	## temp fix
	grep -rl boost/optional/optional_fwd.hpp Swiften | xargs sed \
		-e 's@optional_fwd.hpp@optional.hpp@' -i
	## /temp fix

	default
}

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;

	MYSCONS=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS} -std=c++11"
		cxxflags="${CXXFLAGS} -std=c++11"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		ar="$(tc-getAR)"
		swiften_dll=true
		zlib_includedir=/usr/include
		zlib_libdir=/$(get_libdir)
		lua_includedir=$($(tc-getPKG_CONFIG) --variable includedir ${lua})
		lua_libdir=$($(tc-getPKG_CONFIG) --variable libdir ${lua})
		{boost,libidn,zlib}_bundled_enable=false
		icu=$(usex icu true false)
		try_avahi=$(usex avahi true false)
		try_gconf=$(usex gconf true false)
		try_expat=$(usex expat true false)
		try_libxml=$(usex expat false true)
		experimental_ft=$(usex upnp true false)
		ccache=0
		distcc=1
	)
	# ccache working fine on compile phase, but produces AV's on install phase
}

src_compile() {
	escons "${MYSCONS[@]}" Swiften
}

src_install() {
#	sed -e "/^env_ENV = {/a\\\t'CCACHE_DIR' : '${CCACHE_DIR}'," -i BuildTools/SCons/SConscript.boot

#	^^ ugly hack to semi-fix ccache on install phase (fixes installation,
#	but it anyway trying to rebuild all files (even with ccache it takes few moments),
#	althought do not with ccache=0)

	escons "${MYSCONS[@]}" SWIFTEN_INSTALLDIR="${D}/usr" "${D}/usr" Swiften
}

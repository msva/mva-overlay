# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="keplerproject"

inherit lua

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="curl openssl"

DEPEND="
	curl? ( net-misc/curl )
	!curl? ( net-misc/wget )
	openssl? ( dev-libs/openssl:* )
	!openssl? ( sys-apps/coreutils )
"
RDEPEND="
	${DEPEND}
	app-arch/unzip
"

all_lua_prepare() {
	# Don't die on gentoo's econf calls!
	sed -r \
		-e "/die.*Unknown flag:/d" \
		-i configure

#	sed -r \
#		-e "s@(.*)/lib/luarocks(/rocks)@\1\2@" \
#		-i	src/luarocks/luarocks/cmd/init.lua \
#			src/luarocks/core/cfg.lua \
#			src/luarocks/util.lua
#
	lua_default
}

each_lua_configure() {
	local abi="$(lua_get_abi)"
	local md5 downloader lua incdir
	md5="md5sum"
	downloader="wget"
	lua="$(lua_get_lua)"
	incdir=$(lua_get_pkgvar includedir)

	use curl && downloader="curl"
	use openssl && md5="openssl"

	myeconfargs=()
	myeconfargs+=(
		--prefix=/usr
		--with-lua-lib="/usr/$(get_libdir)"
		--rocks-tree="/usr/$(get_libdir)/lua/luarocks"
		--with-downloader="${downloader}"
		--with-md5-checker="${md5}"
		--lua-version="$(lua_get_abi)"
		--with-lua-include="${incdir}"
		--sysconfdir=/etc
	)
	lua_default
}

each_lua_compile() {
	lua_default build
}

each_lua_install() {
	local abi="$(lua_get_abi)"
	lua_default
	for l in luarocks{,-admin}; do
		mv "${D}/usr/bin/${l}" "${D}/usr/bin/${l}-${abi}"
	done
	keepdir /usr/"$(get_libdir)"/lua/luarocks/lib/luarocks/rocks-"${abi}"
}

pkg_preinst() {
	local abi="$(lua_get_abi)"
	find "${D}" -type f | xargs sed -e "s:${D}::g" -i || die "sed failed"
	for l in luarocks{,-admin}; do
		dosym "${l}-${abi}" "/usr/bin/${l}"
	done
}

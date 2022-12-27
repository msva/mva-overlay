# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )
PYTHON_COMPAT=( python3_{8..11} )

inherit lua-single python-single-r1 git-r3 flag-o-matic

EGIT_REPO_URI="https://github.com/vysheng/tg.git"
EGIT_BRANCH="master"

IUSE="+lua +json +python"
DESCRIPTION="Command line interface client for Telegram"
HOMEPAGE="https://github.com/vysheng/tg"
LICENSE="GPL-2"
SLOT="0"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} ) python? ( ${PYTHON_REQUIRED_USE} )"
RDEPEND="
	sys-libs/zlib:=
	sys-libs/readline:=
	dev-libs/libconfig:=
	dev-libs/openssl:=
	dev-libs/libevent:=
	lua? ( ${LUA_DEPS} )
	json? ( dev-libs/jansson )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup

	eerror "This shit doesn't build anyway: -Werrors of many kinds, linking errors (tries to link from /lib on amd64), and so on"
}

src_configure() {
	local myeconfargs=();
	myeconfargs+=($(use_enable lua liblua))
	myeconfargs+=($(use_enable python))
	myeconfargs+=($(use_enable json))

	myeconfargs+=($(use lua && echo LUA_INCLUDE="$(lua_get_CFLAGS)"))
	myeconfargs+=($(use lua && echo LUA_LIB="$(lua_get_LIBS)"))
	myeconfargs+=($(use lua && echo LUA="${ELUA}"))

	# append-cflags "-Wno-error=stringop-overread"
	append-ldflags "-L/usr/$(get_libdir) -L/$(get_libdir)"
	econf ${myeconfargs[@]}
}

src_install() {
	dobin bin/telegram-cli

	insinto /etc/telegram-cli/
	newins tg-server.pub server.pub
}

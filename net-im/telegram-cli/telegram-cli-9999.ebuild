# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

EGIT_REPO_URI="https://github.com/vysheng/tg.git"
EGIT_BRANCH="master"

IUSE="+lua +json +python"
DESCRIPTION="Command line interface client for Telegram"
HOMEPAGE="https://github.com/vysheng/tg"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-libs/zlib
	sys-libs/readline
	dev-libs/libconfig
	dev-libs/openssl
	dev-libs/libevent
	lua? (
		|| (
			virtual/lua
			dev-lang/lua
			dev-lang/luajit
		)
	)
	json? ( dev-libs/jansson )
	python? ( dev-lang/python )
"

src_configure() {
	local myeconfargs=();
	myeconfargs+=($(use_enable lua liblua))
	myeconfargs+=($(use_enable python))
	myeconfargs+=($(use_enable json))

	myeconfargs+=($(use lua && echo LUA_INCLUDE="$($(tc-getPKG_CONFIG) --cflags lua)"))
	myeconfargs+=($(use lua && echo LUA_LIB="$($(tc-getPKG_CONFIG) --libs lua)"))
	myeconfargs+=($(use lua && echo LUA="lua"))

	econf ${myeconfargs[@]}
}

src_install() {
	dobin bin/telegram-cli

	insinto /etc/telegram-cli/
	newins tg-server.pub server.pub
}

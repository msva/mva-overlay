# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Libpurple (Pidgin) plugin for using a Telegram account"
HOMEPAGE="https://github.com/majn/telegram-purple"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="LGPL-3"
SLOT="0"
IUSE="+libwebp"

DEPEND="
	net-im/pidgin
	dev-libs/openssl:0
	virtual/libc
	libwebp? ( media-libs/libwebp )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable libwebp)
}

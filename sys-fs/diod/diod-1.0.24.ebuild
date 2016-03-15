# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools-utils

AUTOTOOLS_IN_SOURCE_BUILD=1

DESCRIPTION="Distributed I/O Daemon - a 9P file server"
HOMEPAGE="https://github.com/chaos/diod"
SRC_URI="https://github.com/chaos/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE="rdma tcmalloc luajit"

DEPEND="
	|| (
		virtual/lua
		>=dev-lang/lua-5.1:*
		>=dev-lang/luajit-2:*
	)
	sys-apps/tcp-wrappers
	virtual/libc
	sys-libs/libcap
	sys-libs/ncurses:0
	tcmalloc? ( dev-util/google-perftools )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch_user
	./autogen.sh
}

src_configure() {
	local myeconfargs=(
		$(use_enable rdma rdmatrans)
		--with-ncurses
		$(use_with tcmalloc)
		$(use_with luajit lua-suffix jit-5.1)
	)
	autotools-utils_src_configure
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-utils git-r3

DESCRIPTION="Tox plugin for Pidgin/libpurple"
HOMEPAGE="http://tox.dhs.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jin-eld/tox-prpl.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="nacl"

RDEPEND="
	dev-libs/glib:2
	net-im/pidgin
	net-libs/tox[nacl=]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	sed -r \
	-e 's#(define TOXPRPL_ID).*#\1 "prpl-Tox"#' \
	-e 's#(define DEFAULT_NICKNAME).*#\1 "PurpleTox"#' \
	-e 's#(purple_notify_warning.*)#toxprpl_login_after_setup(acct);\n\n\1#' \
	-i src/toxprpl.c
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable nacl static)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --all
}


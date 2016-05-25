# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib-minimal git-r3

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/sregex"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	sed -r \
		-e '/^PREFIX=/s@(PREFIX)=.*@\1=/usr@' \
		-e '/^INSTALL_LIB/s@lib@$(LIBDIR_${ABI})@' \
		-i Makefile
	eapply_user
	multilib_copy_sources
}

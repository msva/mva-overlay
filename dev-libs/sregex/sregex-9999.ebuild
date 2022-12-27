# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"

if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openresty/sregex"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/openresty/${PN}/archive/v${PV//_}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"

src_prepare() {
	sed -r \
		-e '/^PREFIX=/s@(PREFIX)=.*@\1=/usr@' \
		-e '/^INSTALL_LIB/s@lib@$(LIBDIR_${ABI})@' \
		-e '/^CC=/d' \
		-i "${S}"/Makefile
	default
	multilib_copy_sources
}

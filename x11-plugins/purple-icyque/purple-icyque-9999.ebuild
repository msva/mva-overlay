# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit patches toolchain-funcs

DESCRIPTION="ICQ WIM protocol for libpurple"
HOMEPAGE="https://github.com/EionRobb/icyque"
if [[ "${PV}" ==  9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EionRobb/${PN/purple-}.git"
else
	SRC_URI="https://github.com/EionRobb/icyque/archive/78b90a46196d5b6ef5b1727d8139a5fdeea690bb.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	net-im/pidgin
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getBUILD_PKG_CONFIG)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PKG_CONFIG="$(tc-getBUILD_PKG_CONFIG)" \
		install
}

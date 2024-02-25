# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A minimal FIFO based client for Tox"
HOMEPAGE="https://git.2f30.org/ratox/"
EGIT_REPO_URI="git://git.2f30.org/ratox.git"

LICENSE="ISC"
SLOT="0"

RDEPEND="
	net-libs/tox[av]
	media-libs/libv4l
	media-libs/libvpx
	media-libs/openal
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -r \
		-e 's@(^PREFIX).*@\1=/usr@' \
		-i config.mk
	default
}

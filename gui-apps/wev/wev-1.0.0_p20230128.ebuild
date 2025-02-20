# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Wayland event viewer"
HOMEPAGE="https://git.sr.ht/~sircmpwn/wev"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/wev"
else
	if [[ ${PV} == *_p* ]]; then
		MY_SHA="0fc054957275580a31d09679b95d9de9cf69d04a"
		S="${WORKDIR}/${PN}-${MY_SHA}"
	fi
	SRC_URI="https://git.sr.ht/~sircmpwn/wev/archive/${MY_SHA:-${PV}}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/wayland
	dev-libs/wayland-protocols
	x11-libs/libxkbcommon[wayland]
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -e 's/$(LIBS)/$(LIBS) $(LDFLAGS)/' \
		-e 's@/usr/local@/usr@' \
		-i Makefile || die
	tc-export CC
}

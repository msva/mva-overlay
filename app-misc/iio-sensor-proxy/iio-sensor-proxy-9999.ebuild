# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 patches

DESCRIPTION="IIO accelerometer sensor to input device proxy"
HOMEPAGE="https://github.com/hadess/iio-sensor-proxy"
EGIT_REPO_URI="https://github.com/hadess/iio-sensor-proxy"

LICENSE="Unlicense"
# Unknown. There is no info about the license ATM.
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	sys-apps/systemd
	virtual/libgudev
	app-misc/geoclue
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )

src_prepare() {
	patches_src_prepare
	eautoreconf
}

src_configure() {
	local econfargs=(
		--disable-Werror
		--disable-gtk-tests
	)
	econf "${econfargs[@]}"
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="font compression reference code"
HOMEPAGE="https://github.com/google/woff2"
EGIT_REPO_URI="https://github.com/google/${PN}"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="app-arch/brotli"
DEPENDS="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCANONICAL_PREFIXES=ON
		-DNOISY_LOGGING=OFF
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake_src_configure
}

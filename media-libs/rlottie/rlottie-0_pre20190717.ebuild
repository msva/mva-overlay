# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson flag-o-matic patches

MY_SHA="d26c1a5d903b8c344eb21940cd709c2fb20a0195"

DESCRIPTION="A platform independent standalone library that plays Lottie Animation"
HOMEPAGE="https://github.com/Samsung/rlottie"
SRC_URI="
	https://github.com/Samsung/${PN}/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz
"
LICENSE="LGPL-2.1 FTL MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="+cache dumptree libcxx log +module telegram-patches +threads"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	libcxx? (
		sys-devel/clang
		sys-devel/clang-runtime[libcxx]
	)
"

S="${WORKDIR}/${PN}-${MY_SHA}"

src_configure() {
	if use libcxx; then
		export CC=clang CXX=clang++
		append-cxxflags "-stdlib=libc++"
	fi
	if [[ "${CXX}" =~ clang ]]; then
		append-cxxflags "-Wno-error" # https://github.com/Samsung/rlottie/issues/217
	fi
	local emesonargs=(
		$(meson_use threads thread)
		$(meson_use cache)
		$(meson_use module)
		$(meson_use log)
		$(meson_use dumptree)
		-Dexample=false # requires EFL
	)
	meson_src_configure
}

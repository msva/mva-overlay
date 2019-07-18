# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson flag-o-matic patches

MY_SHA="eb2ed2ca903bcec3ceb2af15f6efada664f2bd65"

DESCRIPTION="A platform independent standalone library that plays Lottie Animation"
HOMEPAGE="https://github.com/Samsung/rlottie"
LICENSE="LGPL-2.1 FTL MIT"
SLOT="0"
IUSE="cache dumptree libcxx log +module telegram-patches +threads"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Samsung/${PN}"
else
	SRC_URI="https://github.com/Samsung/${PN}/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"
fi


DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx,compiler-rt]
		sys-libs/libcxx:=
	)
	>=dev-util/meson-0.50.1
"

_isclang() {
	[[ "${CXX}" =~ clang ]]
}

src_configure() {
	if use libcxx; then
		_isclang || export CC=clang CXX=clang++
		append-cxxflags "-stdlib=libc++"
	fi
	_isclang && append-cxxflags "-Wno-error" # https://github.com/Samsung/rlottie/issues/217
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

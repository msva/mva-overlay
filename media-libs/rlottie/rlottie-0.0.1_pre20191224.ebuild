# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson toolchain-funcs flag-o-matic patches

MY_SHA="a718c7e2dfd7d292324ca50d596b02b786299252"

DESCRIPTION="A platform independent standalone library that plays Lottie Animation"
HOMEPAGE="https://github.com/Samsung/rlottie"
LICENSE="LGPL-2.1 FTL MIT"
SLOT="0"
IUSE="+cache dumptree libcxx log +module telegram-patches +threads"

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
		sys-devel/clang-runtime:=[libcxx]
	)
	>=dev-util/meson-0.50.1
"

pkg_pretend() {
	if use libcxx; then
		append-cxxflags "-stdlib=libc++"
	fi
	if [[ $(get-flag stdlib) == "libc++" ]]; then
		if ! tc-is-clang; then
			die "Building with libcxx (aka libc++) as stdlib requires using clang as compiler. Please set CC/CXX in portage.env"
		elif ! use libcxx; then
			die "Building with libcxx (aka libc++) as stdlib requires some dependencies to be also built with it. Please, set USE=libcxx on ${PN} to handle that."
		fi
	fi
}

src_configure() {
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
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic cmake patches

EGIT_REPO_URI="https://github.com/desktop-app/${PN}"
inherit git-r3

DESCRIPTION="WebRTC (video) library (fork) for Telegram clients"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

LICENSE="BSD-3"
SLOT="0"
IUSE="libcxx libressl"

RDEPEND="
	libcxx? (
		sys-devel/clang:=
		sys-devel/clang-runtime:=[libcxx]
		sys-libs/libcxx:=
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"
DEPEND="
	${RDEPEND}
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

src_prepare() {
	cp "${FILESDIR}/cmake/CMakeLists.txt" "${S}"/ || die "Failed to replace cmakelists"
	cp "${FILESDIR}/${PN}.pc.in" "${S}"/ || die "Failed to add .pc"
	patches_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBRARY=ON
	)
	cmake_src_configure
}

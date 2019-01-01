# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="For applications that require seamless and secure communication over HTTP"
HOMEPAGE="https://github.com/Corvusoft/${PN}"

inherit git-r3
# there is no 4.5 release so this is a temporary fix
EGIT_COMMIT="2c4709c6c1dc657a19f364f8d5d0ada523b6a6cd"
EGIT_REPO_URI="https://github.com/Corvusoft/${PN}.git"
KEYWORDS="~amd64"

LICENSE="AGPL-3"
SLOT="0"
IUSE="examples ssl static-libs test"

CMAKE_MIN_VERSION="2.8.10"

RDEPEND="
	>=dev-cpp/asio-1.10
	dev-cpp/catch:0
	ssl? ( dev-libs/openssl:= )
	virtual/pam
	sys-libs/zlib
"
DEPEND="${RDEPEND}
"

DOCS="README.md
	documentation/API.md
	documentation/STANDARDS.md
	documentation/UML.md
"

src_prepare() {
	sed -r -i \
		-e 's/(LIBRARY DESTINATION) "library"/\1 '$(get_libdir)'/' \
		-e 's/(ARCHIVE DESTINATION) "library"/\1 '$(get_libdir)'/' \
		CMakeLists.txt || die

	if use examples; then
		sed -r -i \
			-e 's/\$\{CMAKE_INSTALL_PREFIX\}/\0\/share\/corvusoft\/restbed/' \
			-e 's/(DESTINATION) "resource"/\1 "${CMAKE_INSTALL_PREFIX}\/share\/corvusoft\/restbed\/resource"/' \
			example/CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED=$(usex static-libs OFF ON)
		-DBUILD_TESTS=$(usex test ON OFF)
	)

	for x in {examples,ssl}; do
		mycmakeargs+=( -DBUILD_${x^^}=$(usex $x ON OFF) )
	done

	cmake-utils_src_configure
}

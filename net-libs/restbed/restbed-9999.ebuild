# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="For applications that require seamless and secure communication over HTTP"
HOMEPAGE="https://github.com/Corvusoft/${PN}"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Corvusoft/${PN}.git"
	EGIT_SUBMODULES=()
	KEYWORDS=""
else
	MY_PV=$(replace_version_separator 2 '-')
	MY_P=${PN}-${MY_PV}

	SRC_URI="https://github.com/Corvusoft/${PN}/archive/${MY_PV^^}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	S=${WORKDIR}/${PN}-${MY_PV^^}
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="examples doc ssl static-libs test"

CMAKE_MIN_VERSION="2.8.10"

RDEPEND=">=dev-cpp/asio-9999
	dev-cpp/kashmir
	sys-libs/zlib
	examples? (
		sys-libs/pam
		virtual/logger
	)
	ssl? ( dev-libs/openssl:= )"

DEPEND="${RDEPEND}
	test? ( dev-cpp/catch )"

src_prepare() {
	if use doc ; then DOCS=( README.md
		documentation/API.md
		documentation/DESIGN.md
		documentation/STANDARDS.md
		documentation/UML.md
	)
		else rm README.md
	fi

	if use examples; then
		sed -r -i \
			-e 's/(set\( EXAMPLE_INSTALL_DIR ).*\)/\1\$\{CMAKE_INSTALL_PREFIX\}\/share\/corvusoft\/restbed \)/' \
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

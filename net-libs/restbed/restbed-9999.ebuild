# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="brings asynchronous RESTful functionality to C++14 applications"
HOMEPAGE="https://github.com/Corvusoft/restbed"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Corvusoft/${PN}.git"
	EGIT_SUBMODULES=()
else
	MY_PV=$(ver_rs 2 '-')
	MY_P=${PN}-${MY_PV}

	SRC_URI="https://github.com/Corvusoft/${PN}/archive/${MY_PV^^}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	S=${WORKDIR}/${PN}-${MY_PV^^}
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="examples ipc ssl static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/asio-1.10
	virtual/zlib
	ssl? ( dev-libs/openssl:= )
"

DEPEND="
	${RDEPEND}
	test? ( dev-cpp/catch )
"

DOCS=( README.md documentation/{API,DESIGN,STANDARDS,UML}.md )

src_configure() {
	if use examples ; then
		DOCS+=( documentation/example/. )
	fi

	local mycmakeargs=(
		-DBUILD_SHARED=$(usex static-libs OFF ON)
		-DBUILD_TESTS=$(usex test ON OFF)
	)

	for x in {ipc,ssl}; do
		mycmakeargs+=( -DBUILD_${x^^}=$(usex $x ON OFF) )
	done

	cmake_src_configure
}

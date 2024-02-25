# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="${PV//_/-}"

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://mongocxx.org"
SRC_URI="https://github.com/mongodb/${PN}/archive/refs/tags/r${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs static-mongoc"

DEPEND="dev-libs/boost"
RDEPEND="
	${DEPEND}
	>=dev-libs/mongo-c-driver-1.17.0
	static-mongoc? ( dev-libs/mongo-c-driver[static-libs] )
"

S="${WORKDIR}/${PN}-r${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_VERSION="${PV}"
		-DENABLE_UNINSTALL=OFF
		-DBSONCXX_POLY_USE_BOOST=ON
		-DBUILD_SHARED_AND_STATIC_LIBS="$(usex static-libs ON OFF)"
		-DBUILD_SHARED_LIBS_WITH_STATIC_MONGOC="$(usex static-mongoc ON OFF)"
	)

	cmake_src_configure
}

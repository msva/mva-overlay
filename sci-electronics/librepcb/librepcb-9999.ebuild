# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake virtualx xdg git-r3

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"

LICENSE="GPL-3+"
SLOT="0"

EGIT_REPO_URI="https://github.com/LibrePCB/LibrePCB"

IUSE="opencascade"

BDEPEND="
	app-arch/unzip
	dev-qt/qttools:6[linguist]
"

RDEPEND="
	dev-cpp/muParser:=
	dev-libs/quazip:=[qt6(-)]
	dev-qt/qtbase[concurrent,gui,network,opengl,sql,sqlite,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	opencascade? ( sci-libs/opencascade:= )
	virtual/zlib
	virtual/opengl
"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs+=(
		-DBUILD_TESTS=$(usex test ON OFF)
		-DQT_MAJOR_VERSION=6
		-DUNBUNDLE_GTEST=ON
		-DUNBUNDLE_MUPARSER=ON
		-DUNBUNDLE_QUAZIP=ON
		-DUSE_OPENCASCADE=$(usex opencascade 1 0)
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/tests/unittests || die
	# https://github.com/LibrePCB/LibrePCB/issues/516
	# virtx ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername
	virtx ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername:CategoryTreeModelTest.testSort:BoardPlaneFragmentsBuilderTest.testFragments:BoardGerberExportTest.test
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn
	ewarn "LibrePCB builds might not be exactly reproducible with e.g. -march={native,haswell,...}."
	ewarn "This can cause minor issues, see for example:"
	ewarn "https://github.com/LibrePCB/LibrePCB/issues/516"
	ewarn "For a completely reproducible build use: -march=x86-64."
	ewarn
}

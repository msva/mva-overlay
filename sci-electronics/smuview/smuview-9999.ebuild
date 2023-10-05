# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake xdg-utils git-r3

EGIT_REPO_URI="https://github.com/knarfS/smuview.git"
DESCRIPTION="SmuView is a Qt based source measure unit GUI for sigrok"
HOMEPAGE="https://github.com/knarfS/smuview"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

DEPEND="
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/glib-2.28.0
	>=dev-qt/qtcore-5.7
	>=dev-qt/qtgui-5.7
	>=dev-qt/qtwidgets-5.7
	>=x11-libs/qwt-6.1.2
	>=dev-libs/boost-1.54
	>=sci-libs/libsigrok-0.6.0[cxx]
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( dev-ruby/asciidoctor )
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
	if use doc; then
		sed -i \
			-e "/MANUAL_INST_SUBDIR/ s:share/doc/smuview:share/doc/${PF}:" \
			manual/CMakeLists.txt || die
	else
		sed -i \
			-e "s/add_subdirectory(manual)//" \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(use doc && echo manual-html)
}

pkg_postrm() {
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_icon_cache_update
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="A cross-platform IRC framework written with Qt"
HOMEPAGE="http://communi.github.io/"
SRC_URI="https://github.com/communi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu qml test examples +uchardet"

RDEPEND="
	dev-qt/qtcore:5=
	icu? ( dev-libs/icu )
	uchardet? ( app-i18n/uchardet )
"

DEPEND="
	${RDEPEND}
	test? (
		dev-qt/qttest:5=
	)
"

src_prepare() {

	use qml || (
		sed -i \
			-e '/SUBDIRS/s@ imports@@' \
			src/src.pro
	)

	UCHD="${S}"/src/3rdparty/uchardet-0.0.1/uchardet.pri
	echo "CONFIG *= link_pkgconfig" > "$UCHD"
	echo "PKGCONFIG += uchardet" >> "$UCHD"

	export INSTALL_ROOT="${D}"

	default
}

src_configure() {
	local icu="icu";
	local ex="examples";
	local eqmake;

	use icu || icu="no_icu";
	use examples || ex="no_examples"

	eqmake5 libcommuni.pro \
		-config "${ex}" \
		-config no_rpath \
		-config "${icu}" \
		$(use test || echo "-config no_tests") \
		$(use qml || echo "-config no_install_imports -config no_install_qml")
}

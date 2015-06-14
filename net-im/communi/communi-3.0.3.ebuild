# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit base qmake-utils

DESCRIPTION="A cross-platform IRC framework written with Qt"
HOMEPAGE="https://github.com/communi/libcommuni"
SRC_URI="https://github.com/communi/libcommuni/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu test examples qt4 qt5"

REQUIRED_USE="
	^^ ( qt4 qt5 )
"

RDEPEND="
	dev-qt/qtcore
	dev-qt/qtdeclarative
	!icu? ( dev-libs/uchardet )
	icu? ( dev-libs/icu )
"
DEPEND="
	${RDEPEND}
	test? ( dev-qt/qttest )
"

S="${WORKDIR}/lib${P}"

src_prepare() {
	UCHD="${S}"/src/3rdparty/uchardet-0.0.1/uchardet.pri
	echo "CONFIG *= link_pkgconfig" > "$UCHD"
	echo "PKGCONFIG += uchardet" >> "$UCHD"
	base_src_prepare
}

src_configure() {
	local qmake=eqmake4;
	use qt5 && qmake=eqmake5;
	${qmake} libcommuni.pro \
		$(use examples || echo "-config no_examples") \
		$(use icu && echo "-config icu") \
		$(use test || echo "-config no_tests")
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

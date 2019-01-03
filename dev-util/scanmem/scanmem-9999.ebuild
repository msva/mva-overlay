# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )

inherit autotools eutils python-single-r1 git-r3

DESCRIPTION="Locate and modify variables in executing processes"
HOMEPAGE="https://github.com/scanmem/scanmem"
SRC_URI=""
EGIT_REPO_URI="https://github.com/scanmem/scanmem"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gui"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}
	gui? (
		${PYTHON_DEPS}
		dev-python/pygobject:3
		sys-auth/polkit
	)"

REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use gui && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i "/CFLAGS/d" Makefile.am || die
	default
	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable gui)
}

src_install() {
	default
	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
		python_fix_shebang "${D}"
	fi
}

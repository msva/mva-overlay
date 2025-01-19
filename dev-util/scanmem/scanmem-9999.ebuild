# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..13} python3_13t )

inherit autotools python-single-r1 git-r3

DESCRIPTION="Locate and modify variables in executing processes"
HOMEPAGE="https://github.com/scanmem/scanmem"
EGIT_REPO_URI="https://github.com/scanmem/scanmem"

LICENSE="GPL-3"
SLOT="0"
IUSE="gui static-libs"

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
	default
	sed -i "/CFLAGS/d" Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--docdir="/usr/share/doc/${PF}"
		--with-readline
		$(use_enable gui)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
		python_fix_shebang "${D}"
	fi
	find "${ED}" -type f -name "*.la" -delete || die
}

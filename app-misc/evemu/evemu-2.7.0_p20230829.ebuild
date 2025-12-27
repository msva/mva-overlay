# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..14} python3_13t )

inherit python-single-r1 autotools

DESCRIPTION="tools and bindings for kernel evdev device emulation, data capture, and replay"
HOMEPAGE="https://www.freedesktop.org/wiki/Evemu/"

# SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

# FIXME: remove on next versions (after 2.7.0)
MY_SHA="ac0531bbf81c4a58918c7b7837ba87c76edef639"
SRC_URI="https://gitlab.freedesktop.org/libevdev/${PN}/-/archive/${MY_SHA}/${PN}-${MY_SHA}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_SHA}"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/libevdev-1.2.99.902"
DEPEND="app-arch/xz-utils
	${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable python python-bindings)
}

src_test() {
	if use python ; then
		if [[ ! ${EUID} -eq 0 ]] || has sandbox $FEATURES || has usersandbox $FEATURES ; then
			ewarn "Tests require userpriv, sandbox, and usersandbox to be disabled in FEATURES."
		else
			emake check
		fi
	fi
}

src_install() {
	default
	find "${D}" -type f -name '*.la' -delete
}

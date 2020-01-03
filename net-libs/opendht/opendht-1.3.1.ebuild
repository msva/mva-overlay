# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit eutils git-r3 cmake-utils python-r1

DESCRIPTION="A lightweight C++11 Distributed Hash Table implementation"
HOMEPAGE="https://github.com/savoirfairelinux/opendht/blob/master/README.md"
EGIT_REPO_URI="https://github.com/savoirfairelinux/${PN}.git"

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	EGIT_COMMIT="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"

SLOT="0"

IUSE="doc python static-libs tools"

DEPEND="
	dev-libs/msgpack
	net-libs/gnutls
	python? ( dev-python/cython[$(python_gen_usedep python3_{4,5,6})] )
	tools? ( sys-libs/readline:0 )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOPENDHT_PYTHON=$(usex python)
		-DOPENDHT_STATIC=$(usex static-libs)
		-DOPENDHT_TOOLS=$(usex tools)
	)
	cmake-utils_src_configure
}

src_install() {
	use !doc && rm README.md
	cmake-utils_src_install
}

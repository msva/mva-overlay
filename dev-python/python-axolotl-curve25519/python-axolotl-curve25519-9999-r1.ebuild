# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

DESCRIPTION="Python wrapper for the curve25519 library"
HOMEPAGE="https://github.com/tgalal/python-axolotl-curve25519"
EGIT_REPO_URI="https://github.com/tgalal/python-axolotl-curve25519.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( README.md )

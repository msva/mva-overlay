# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..12} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="Python port of libaxolotl"
HOMEPAGE="https://github.com/tgalal/python-axolotl"
EGIT_REPO_URI="https://github.com/tgalal/python-axolotl.git"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/python-axolotl-curve25519[${PYTHON_USEDEP}]
"

DOCS=( README.md )

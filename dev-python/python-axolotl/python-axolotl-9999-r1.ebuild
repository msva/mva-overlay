# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8
PYTHON_COMPAT=( python3_{8..14} python3_13t )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="Python port of libaxolotl"
HOMEPAGE="https://github.com/tgalal/python-axolotl"
EGIT_REPO_URI="https://github.com/tgalal/python-axolotl.git"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/python-axolotl-curve25519[${PYTHON_USEDEP}]
"

DOCS=( README.md )

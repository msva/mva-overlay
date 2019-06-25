# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
PYTHON_REQ_USE="readline"

inherit distutils-r1 patches git-r3

DESCRIPTION="A library that enables you to build applications which use the WhatsApp service"
HOMEPAGE="https://github.com/tgalal/yowsup"
EGIT_REPO_URI="https://github.com/tgalal/yowsup.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-python/configargparse[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/python-axolotl-curve25519[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

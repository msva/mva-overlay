# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
# protobuf ^
PYTHON_REQ_USE="readline"
#DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 git-r3

DESCRIPTION="Python WhatsApp library and CLI client"
HOMEPAGE="https://github.com/tgalal/yowsup"
#SRC_URI="https://github.com/tgalal/yowsup/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tgalal/yowsup"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+encryption"

RDEPEND="
	>=dev-python/axolotl-0.1.7[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	encryption? (
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
		dev-python/axolotl-curve25519[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.md )

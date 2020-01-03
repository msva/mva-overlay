# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
# python3_{4,5,6} )
# ^ e4u
#pypy{,3} )
# ^ protobuf
inherit distutils-r1 git-r3

DESCRIPTION="A WhatsApp XMPP Gateway based on Spectrum 2 and Yowsup 2"
HOMEPAGE="https://github.com/stv0g/transwhat"
EGIT_REPO_URI="https://github.com/stv0g/transwhat.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-python/e4u[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	net-im/yowsup[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( "INSTALL.rst" "README.rst" "USAGE.rst" )

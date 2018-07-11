# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 git-r3

DESCRIPTION="a WhatsApp XMPP Gateway backend for net-im/spectrum"
HOMEPAGE="https://github.com/stv0g/transwhat/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/stv0g/transwhat/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	net-im/yowsup[encryption,${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/e4u[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.md )

src_prepare() {
	cp "${FILESDIR}"/setup.py "${S}"/
	distutils-r1_src_prepare
}

src_install() {
	insinto "/usr/lib/${PN}"
	doins *.py
	exeinto "/usr/lib/${PN}"
	doexe "${PN}".py
	distutils-r1_src_install
}

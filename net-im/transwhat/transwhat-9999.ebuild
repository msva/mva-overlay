# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..13} python3_13t )
#pypy{,3} )
# ^ protobuf
inherit distutils-r1 git-r3

DESCRIPTION="A WhatsApp XMPP Gateway based on Spectrum 2 and Yowsup 3"
HOMEPAGE="https://github.com/stv0g/transwhat"
EGIT_REPO_URI="https://github.com/stv0g/transwhat.git"
EGIT_BRANCH="yowsup-3"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/pyspectrum2[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	net-im/yowsup[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( "INSTALL.rst" "README.rst" "USAGE.rst" )

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="readline"

inherit distutils-r1 git-r3

DESCRIPTION="A library that enables you to build applications which use the WhatsApp service"
HOMEPAGE="https://github.com/tgalal/yowsup"
EGIT_REPO_URI="https://github.com/tgalal/yowsup.git"

LICENSE="GPL-3"
SLOT="0"

# This package contains no-op tests, so they actually cannot be run
RESTRICT="test"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	dev-python/consonance[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-axolotl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-3.2.3_p20190905-fix-install-path.patch" )

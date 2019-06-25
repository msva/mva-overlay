# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 pypy )
#python3_{4,5,6} )
#pypy{,3} )

inherit distutils-r1 patches git-r3

DESCRIPTION="A library for handling unicode emoji and carrier's emoji"
HOMEPAGE="https://github.com/lambdalisue/e4u"
EGIT_REPO_URI="https://github.com/lambdalisue/e4u.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.rst )

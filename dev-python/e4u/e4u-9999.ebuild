# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 git-r3

DESCRIPTION="Bundle Library of emoji4unicode at Google"
HOMEPAGE="https://github.com/lambdalisue/e4u"
EGIT_REPO_URI="https://github.com/lambdalisue/e4u.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	<dev-python/beautifulsoup-4:python-2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.rst )

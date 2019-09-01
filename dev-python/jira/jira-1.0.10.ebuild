# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
#,6} pypy{,3} )
# ^ ipython, requests-oauthlib, filemagic has only 3_5. And totally no pypy

inherit distutils-r1
# vcs-snapshot

DESCRIPTION="Python library for interacting with JIRA via REST APIs."
HOMEPAGE="https://pypi.python.org/pypi/jira"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# requests-oauthlib have no arm
IUSE="filemagic ipython oauth"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	oauth? (
		>=dev-python/requests-oauthlib-0.6.1[${PYTHON_USEDEP}]
	)
	ipython? ( dev-python/ipython[${PYTHON_USEDEP}] )
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	filemagic? (
		dev-python/filemagic[${PYTHON_USEDEP}]
	)
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	sed -i -e 's/.*setup_requires.*//g' "${S}"/setup.py || die
}

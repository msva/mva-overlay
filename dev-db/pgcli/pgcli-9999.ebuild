# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )
#DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 git-r3

DESCRIPTION="Postgres CLI with autocompletion and syntax highlighting"
HOMEPAGE="http://pgcli.com/ https://pypi.python.org/pypi/pgcli"
EGIT_REPO_URI="https://github.com/dbcli/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/pgspecial-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.1[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.9[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.5.4[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.2.2[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/humanize-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.1.6[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.9[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# remove tests which require a live database
	rm tests/test_pgexecute.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die
}

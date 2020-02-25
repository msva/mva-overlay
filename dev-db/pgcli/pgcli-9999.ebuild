# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 git-r3

DESCRIPTION="Postgres CLI with autocompletion and syntax highlighting"
HOMEPAGE="http://pgcli.com/ https://pypi.python.org/pypi/pgcli"
EGIT_REPO_URI="https://github.com/dbcli/${PN}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="keyring"

RDEPEND="
	>=dev-python/cli_helpers-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/humanize-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/pgspecial-1.11.5[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.0.6[${PYTHON_USEDEP}]
	<dev-python/psycopg-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.9[${PYTHON_USEDEP}]
	keyring? ( >=dev-python/keyring-12.2.0[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

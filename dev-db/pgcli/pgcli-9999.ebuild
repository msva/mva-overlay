# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 git-r3

DESCRIPTION="Postgres CLI with autocompletion and syntax highlighting"
HOMEPAGE="http://pgcli.com/ https://pypi.python.org/pypi/pgcli"
EGIT_REPO_URI="https://github.com/dbcli/pgcli"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="keyring +ssh"

RDEPEND="$(python_gen_cond_dep '
	>=dev-python/cli_helpers-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/pendulum-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pgspecial-1.11.8[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-3.0.0[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/sqlparse-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.9[${PYTHON_USEDEP}]
	ssh? ( >=dev-python/sshtunnel-0.4.0[${PYTHON_USEDEP}] )
	keyring? ( >=dev-python/keyring-12.2.0[${PYTHON_USEDEP}] )')
"
DEPEND="
	${RDEPEND}
"

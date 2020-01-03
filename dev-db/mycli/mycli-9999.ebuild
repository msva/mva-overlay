# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
EGIT_REPO_URI="https://github.com/dbcli/mycli.git"
inherit distutils-r1 git-r3

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="https://mycli.net"
SRC_URI=""
LICENSE="BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="ssh"
RDEPEND="
	>dev-python/cli_helpers-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.4.0[${PYTHON_USEDEP}]
	ssh? ( dev-python/paramiko[${PYTHON_USEDEP}] )
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

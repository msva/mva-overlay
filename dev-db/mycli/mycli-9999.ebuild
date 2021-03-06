# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
EGIT_REPO_URI="https://github.com/dbcli/mycli.git"

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 git-r3

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"

HOMEPAGE="https://www.mycli.net"
LICENSE="BSD MIT"
SLOT="0"
IUSE="ssh test"
RESTRICT="!test? ( test )"

RDEPEND="$(python_gen_cond_dep '
	>=dev-python/cli_helpers-1.1.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_MULTI_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/prompt_toolkit-3.0.0[${PYTHON_MULTI_USEDEP}]
	<dev-python/prompt_toolkit-4.0.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_MULTI_USEDEP}]
	>=dev-python/pymysql-0.9.2[${PYTHON_MULTI_USEDEP}]
	>=dev-python/sqlparse-0.3.0[${PYTHON_MULTI_USEDEP}]
	<dev-python/sqlparse-0.4.0[${PYTHON_MULTI_USEDEP}]
	ssh? ( dev-python/paramiko[${PYTHON_MULTI_USEDEP}] )')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

BDEPEND="test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_MULTI_USEDEP}]') )"

src_prepare() {
	rm -r test || die # temp dirty hack
	distutils-r1_src_prepare
}

python_test() {
	pytest --capture=sys \
		--showlocals \
		--doctest-modules \
		--doctest-ignore-import-errors \
		--ignore=setup.py \
		--ignore=mycli/magic.py \
		--ignore=mycli/packages/parseutils.py \
		--ignore=test/features
}

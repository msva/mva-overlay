# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="
	https://pygls.readthedocs.io/en/latest/
	https://pypi.org/project/pygls/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# arm arm64 ...
# ^ cattrs
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/lsprotocol[${PYTHON_USEDEP}]
	<dev-python/typeguard-4.0.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/cattrs[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

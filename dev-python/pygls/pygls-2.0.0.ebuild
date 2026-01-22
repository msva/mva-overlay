# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..14} python3_13t )
inherit distutils-r1 pypi

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="
	https://pygls.readthedocs.io/en/latest/
	https://pypi.org/project/pygls/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/lsprotocol[${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
"
# websockets? ( dev-python/websockets[${PYTHON_USEDEP}] )
DEPEND="
	${RDEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
"
# BDEPEND="
# 	test? (
# 		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
# 		dev-python/mock[${PYTHON_USEDEP}]
# 		dev-python/cattrs[${PYTHON_USEDEP}]
# 	)
# "

distutils_enable_tests pytest

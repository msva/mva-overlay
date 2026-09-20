# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{13..15} python3_13t pypy3{,_11})
inherit distutils-r1 pypi

DESCRIPTION="A pythonic generic language server"
HOMEPAGE="https://pypi.org/project/tftpy/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

EPYTEST_PLUGINS=()
# distutils_enable_tests pytest

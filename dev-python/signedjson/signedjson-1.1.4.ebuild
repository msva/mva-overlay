# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1
#DISTUTILS_USE_SETUPTOOLS=pyproject.toml

DESCRIPTION="Signs JSON objects with ED25519 signatures."
HOMEPAGE="https://github.com/matrix-org/python-signedjson https://pypi.python.org/pypi/signedjson"
#SRC_URI="https://github.com/matrix-org/python-signedjson/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/matrix-org/python-signedjson/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"

distutils_enable_tests pytest

S="${WORKDIR}/python-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/canonicaljson-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/unpaddedbase64-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pynacl-0.3.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

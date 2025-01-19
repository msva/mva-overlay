# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..13} python3_13t )
DISTUTILS_USE_PEP517=setuptools

PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="An LDAP3 auth provider for Synapse "
HOMEPAGE="https://github.com/matrix-org/matrix-synapse-ldap3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
# arm
# ^ ldap3

RDEPEND="
	>=dev-python/twisted-15.1.0[${PYTHON_USEDEP}]
	>=dev-python/ldap3-2.8[${PYTHON_USEDEP}]
	dev-python/service-identity[${PYTHON_USEDEP}]
"

RESTRICT="test"

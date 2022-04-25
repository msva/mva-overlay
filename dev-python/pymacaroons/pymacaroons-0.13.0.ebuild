# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="a Python implementation of Macaroons. They’re better than cookies!"
HOMEPAGE="https://github.com/ecordell/pymacaroons https://pypi.org/project/pymacaroons/"
SRC_URI="https://github.com/ecordell/pymacaroons/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/six-1.8[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.1.2[${PYTHON_USEDEP}]
	<dev-python/pynacl-2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

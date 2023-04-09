# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Quality Assurance (QA) tools for cmake (formerly cmake_format)"
HOMEPAGE="https://github.com/cheshirekow/cmake_format"
SRC_URI="https://github.com/cheshirekow/cmake_format/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cmake_format-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
"

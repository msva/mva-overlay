# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="Common code for Synapse, Sydent and Sygnal"
HOMEPAGE="https://github.com/matrix-org/matrix-python-common"
SRC_URI="https://github.com/matrix-org/matrix-python-common/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_unpack() {
	default
	S=${WORKDIR}/matrix-python-common-${PV}
}

src_prepare() {
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
}

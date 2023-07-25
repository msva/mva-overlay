# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multibuild multiprocessing

DESCRIPTION="Quality Assurance (QA) tools for cmake (formerly cmake_format)"
HOMEPAGE="https://github.com/cheshirekow/cmake_format"
SRC_URI="https://github.com/cheshirekow/cmake_format/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cmake_format-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=("${PN}"/doc/README.rst)

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/wheel[${PYTHON_USEDEP}]
"

python_compile() {
	local jobs=$(makeopts_jobs "${MAKEOPTS} ${*}")
	esetup.py build -j "${jobs}"
}

qa_hack() { ${*}; }

python_install() {
	local root=${D}/_${EPYTHON}
	esetup.py install "${DISTUTILS_ARGS[@]}" --skip-build --root="${root}"
	multibuild_merge_root "${root}" "${D}"
	qa_hack _distutils-r1_wrap_scripts /usr/bin
	python_optimize
}

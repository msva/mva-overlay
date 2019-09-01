# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_python_module.so")

GITHUB_A="arut"
GITHUB_PN="nginx-python-module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Nginx Python Module"
HOMEPAGE="https://github.com/arut/nginx-python-module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	dev-lang/python:2.7
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.rst,TODO} )

nginx-module-configure() {
	export PYTHON_CONFIG="/usr/bin/python2.7-config"
}

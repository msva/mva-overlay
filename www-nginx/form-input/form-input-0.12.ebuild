# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_http_form_input_module.so")

GITHUB_A="calio"
GITHUB_PN="${PN}-nginx-module"
GITHUB_PV="v${PV}"
NDK=1

inherit nginx-module

DESCRIPTION="Converts POST/PUT urlencoded body (forms) to nginx variables."
HOMEPAGE="https://github.com/calio/form-input-nginx-module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

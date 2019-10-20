# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_auth_pam_module.so")

GITHUB_A="sto"
GITHUB_PN="ngx_http_auth_pam_module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="A module to use PAM for simple http authentication"
HOMEPAGE="https://github.com/sto/ngx_http_auth_pam_module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	sys-libs/pam
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

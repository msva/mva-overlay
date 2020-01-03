# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_encrypted_session_module.so")

GITHUB_A="openresty"
GITHUB_PN="${PN}-nginx-module"
GITHUB_PV="v${PV}"
NDK=1

inherit nginx-module

DESCRIPTION="Support for AES(+MAC) variables enc-/decryption in NgX config"
HOMEPAGE="https://github.com/openresty/encrypted-session-nginx-module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	dev-libs/openssl:0
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

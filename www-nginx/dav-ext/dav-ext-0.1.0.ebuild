# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_dav_ext_module.so")

GITHUB_A="arut"
GITHUB_PN="nginx-dav-ext-module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="NGINX WebDAV missing methods support (PROPFIND & OPTIONS)"
HOMEPAGE="https://github.com/arut/nginx-dav-ext-module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	dev-libs/expat
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.rst )

nginx-module-configure() {
	myconf+=("--with-http_dav_module")
}

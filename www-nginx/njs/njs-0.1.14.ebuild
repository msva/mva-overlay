# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_js_module.so" "ngx_stream_js_module.so")
NG_MOD_SUFFIX="/nginx"

GITHUB_A="nginx"

inherit nginx-module

DESCRIPTION="A JS subset for location&variable handlers (HTTP+STREAM)"
HOMEPAGE="http://nginx.org/en/docs/njs_about.html"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/../README )

nginx-module-setup() {
	! has_version 'www-servers/nginx[stream]' &&
	! has_version 'www-servers/nginx[http]' &&
	die "This module needs at least one of HTTP or STREAM modules enabled in NginX"
}

nginx-module-configure() {
	has_version 'www-servers/nginx[stream]' &&
		myconf+=("--with-stream=dynamic") ||
		NG_MOD_LIST=(${NG_MOD_LIST[@]%ngx_stream*})
	has_version 'www-servers/nginx[http]' ||
		NG_MOD_LIST=(${NG_MOD_LIST[@]%ngx_http*})
}

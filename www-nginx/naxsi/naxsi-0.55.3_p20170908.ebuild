# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_naxsi_module.so")

GITHUB_A="nbs-system"
GITHUB_PN="naxsi"
GITHUB_SHA="6d7baa24cf83bcaf1fb93a5354f4de0641fc2149"
NG_MOD_SUFFIX="/naxsi_src"

inherit nginx-module

DESCRIPTION="Open-source, high performance, low rules maintenance WAF"
HOMEPAGE="https://www.nbs-system.com/en/it-security/it-security-tools-open-source/naxsi/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[pcre]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/../README.md )

nginx-module-install() {
	insinto "${NGINX_CONF_PATH}"
	doins ../naxsi_config/*rules
}

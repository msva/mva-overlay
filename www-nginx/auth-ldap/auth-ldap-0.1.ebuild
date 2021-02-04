# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_http_auth_ldap_module.so")

GITHUB_A="kvspb"
GITHUB_PN="nginx-auth-ldap"
GITHUB_SHA="42d195d7a7575ebab1c369ad3fc5d78dc2c2669c"

inherit nginx-module

DESCRIPTION="LDAP authentication module"
HOMEPAGE="https://github.com/kvspb/nginx-auth-ldap"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="ssl"

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[ssl=]
	net-nds/openldap[ssl=]
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,example.conf} )

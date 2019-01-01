# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_cache_purge_module.so")

GITHUB_A="nginx-modules"
GITHUB_PN="ngx_cache_purge"

inherit nginx-module

DESCRIPTION="Adds support for purge ngx_http_(fastcgi|proxy|scgi|uwsgi)_module cache backend"
HOMEPAGE="https://github.com/nginx-modules/ngx_cache_purge"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="${CDEPEND}"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README,TODO}.md )

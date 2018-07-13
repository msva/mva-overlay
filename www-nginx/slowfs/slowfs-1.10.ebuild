# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_slowfs_module.so")

GITHUB_A="nginx-modules"
GITHUB_PN="ngx_slowfs_cache"
GITHUB_SHA="ec5c9257a571839f93f56f863af8728c923839e8"

inherit nginx-module

DESCRIPTION="nginx module which adds ability to cache static files"
HOMEPAGE="https://github.com/nginx-modules/ngx_slowfs_cache"

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

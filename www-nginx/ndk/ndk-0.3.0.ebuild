# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ndk_http_module.so")

GITHUB_A="simpl"
GITHUB_PN="ngx_devel_kit"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="an Nginx module framework for another modules"
HOMEPAGE="https://github.com/simpl/ngx_devel_kit"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="${CDEPEND}"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

nginx-module-install() {
	ng_dohdr src/ndk*.h objs/ndk*.h
}

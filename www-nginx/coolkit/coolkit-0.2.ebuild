# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_coolkit_module.so")

GITHUB_A="FRiCKLE"
GITHUB_PN="ngx_coolkit"

inherit nginx-module

DESCRIPTION="collection of small and useful nginx add-ons"
HOMEPAGE="https://github.com/FRiCKLE/ngx_coolkit"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README,valgrind.suppress} )

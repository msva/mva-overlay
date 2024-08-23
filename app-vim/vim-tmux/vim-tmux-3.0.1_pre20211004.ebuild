# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_SHA="cfe76281efc29890548cf9eedd42ad51c7a1faf0"
inherit vim-plugin

DESCRIPTION="vim plugin: tmux support for vim"
HOMEPAGE="https://github.com/tmux-plugins/vim-tmux"
SRC_URI="https://github.com/tmux-plugins/${PN}/archive/${MY_SHA:-v${PV}}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"

LICENSE="public-domain MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_SHA="4e77341a2f8b9b7e41e81e9debbcecaea5987c85"
inherit vim-plugin

DESCRIPTION="vim plugin: tmux support for vim"
HOMEPAGE="https://github.com/tmux-plugins/vim-tmux"
SRC_URI="https://github.com/tmux-plugins/${PN}/archive/${MY_SHA:-v${PV}}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain MIT"
KEYWORDS="alpha ~alpha amd64 arm ~arm ~arm64 ~hppa ~ia64 ia64 ~mips ppc ppc64 ~s390 ~sparc x86"

S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"

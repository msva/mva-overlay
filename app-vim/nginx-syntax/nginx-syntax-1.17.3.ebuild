# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: Nginx configuration files syntax"
HOMEPAGE="https://nginx.org/"
LICENSE="vim"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux"
SRC_URI="https://nginx.org/download/${P//-syntax}.tar.gz"

S="${WORKDIR}/${P//-syntax}/contrib/vim"

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: Nginx configuration files syntax"
HOMEPAGE="https://nginx.org/"
LICENSE="vim"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
SRC_URI="https://nginx.org/download/${P//-syntax}.tar.gz"

S="${WORKDIR}/${P//-syntax}/contrib/vim"

# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit meson-multilib

DESCRIPTION="Library for extracting DWARF data from code objects"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="app-arch/xz-utils"

DOCS=( NEWS README README.md README.cmake )

# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{4,5,6,7} pypy3)
inherit python-r1

DESCRIPTION="Amazfit Bip Font Parser (& Packer)"
HOMEPAGE="https://myamazfit.ru/threads/parser-shriftov-amazfit-bip.96/"
SRC_URI="https://gist.github.com/raw/7ffbab5b23b35207525a7a05295cf67e -> bip_font_tool-${PV}.py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pillow
"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir -p "${S}"
	cp "${DISTDIR}/${A}" "${S}"
}

src_prepare() {
	default
	sed -r \
		-e '1i#!/usr/bin/env python' \
		-i ${A}
}

src_install() {
	python_foreach_impl python_newscript ${A} "${PN}"
}

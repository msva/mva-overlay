# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_{8..13} pypy3)
inherit python-r1

DESCRIPTION="Amazfit Bip Font Parser (& Packer)"
HOMEPAGE="https://web.archive.org/web/20220517220033/https://myamazfit.ru/threads/parser-shriftov-amazfit-bip.96/"
SRC_URI="https://gist.githubusercontent.com/raw/7ffbab5b23b35207525a7a05295cf67e -> bip_font_tool-${PV}.py"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pillow
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}"
}

src_prepare() {
	default
	sed -r \
		-e '1i#!/usr/bin/env python' \
		-i ${A}
}

src_install() {
	python_foreach_impl python_newscript "${A}" "${PN}"
}

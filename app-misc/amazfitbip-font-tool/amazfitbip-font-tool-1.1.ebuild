# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_{8..11} pypy3)
inherit python-r1

DESCRIPTION="Amazfit Bip Font Parser (& Packer)"
HOMEPAGE="https://myamazfit.ru/threads/parser-shriftov-amazfit-bip.96/"
SRC_URI="https://gist.github.com/raw/7ffbab5b23b35207525a7a05295cf67e -> bip_font_tool-${PV}.py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
# ^ ~arm64: pillow

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pillow
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"

src_unpack() {
	# mkdir -p "${S}"
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

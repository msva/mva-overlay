# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A color and B&W emoji SVG-in-OpenType font"
HOMEPAGE="https://github.com/eosrei/emojione-color-font"
SRC_URI="${HOMEPAGE}/releases/download/v${PV//_/-}/EmojiOneColor-SVGinOT-Linux-${PV//_/-}.tar.gz"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="media-fonts/dejavu[X?]"
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"
DOCS="README.md"
FONT_CONF=( fontconfig/56-emojione-color.conf )

S="${WORKDIR}/EmojiOneColor-SVGinOT-Linux-${PV//_/-}"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Adds String#display_width to get the display size using EastAsianWidth.txt"
HOMEPAGE="https://github.com/janlelis/unicode-display_width"
SRC_URI="https://github.com/janlelis/unicode-display_width/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="1"
IUSE=""

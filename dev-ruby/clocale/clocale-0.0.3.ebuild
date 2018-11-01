# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="A Ruby gem that wraps C locale functions"
HOMEPAGE="https://github.com/avdv/clocale"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

each_ruby_configure() {
	${RUBY} -C "ext/${PN}" extconf.rb
}

each_ruby_compile() {
	emake -C "ext/${PN}" V=1
	mkdir "lib/${PN}"
	cp "ext/${PN}/${PN}.so" "lib/${PN}/"
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

USE_RUBY="ruby30 ruby31 ruby32 ruby33"

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

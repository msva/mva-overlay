# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32 ruby33"

inherit ruby-fakegem

DESCRIPTION="Manpages wrapper for rubygems"
HOMEPAGE="https://github.com/bitboxer/manpages"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

all_ruby_compile() {
	# Kludge for pkgcheck
	all_fakegem_compile
}

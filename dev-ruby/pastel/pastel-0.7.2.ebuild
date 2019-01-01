# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Terminal strings styling with intuitive and clean API."
HOMEPAGE="https://github.com/peter-murach/pastel"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

ruby_add_rdepend '
	=dev-ruby/equatable-0.5*
	=dev-ruby/tty-color-0.4*'

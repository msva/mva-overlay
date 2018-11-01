# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Beautiful and powerful interactive command line prompt with a robust API"
HOMEPAGE="http://peter-murach.github.io/tty"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

ruby_add_rdepend '
	=dev-ruby/necromancer-0.4*
	=dev-ruby/pastel-0.7*
	=dev-ruby/timers-4*
	=dev-ruby/tty-cursor-0.6*
	=dev-ruby/tty-reader-0.4*'

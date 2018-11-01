# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Flexible and intuitive table generator"
HOMEPAGE="https://rubygems.org/gems/tty-table"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

ruby_add_rdepend '
	=dev-ruby/equatable-0.5*
	=dev-ruby/necromancer-0.4*
	=dev-ruby/pastel-0.7*
	=dev-ruby/tty-screen-0.6*
	=dev-ruby/strings-0.1*
'
#	=dev-ruby/unicode-display_width-1.1*
#	=dev-ruby/verse-0.5*

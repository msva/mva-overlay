# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Flexible and intuitive table generator"
HOMEPAGE="http://peter-murach.github.io/tty/"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend '
	=dev-ruby/equatable-0.5*
	=dev-ruby/necromancer-0.4*
	=dev-ruby/pastel-0.7*
	=dev-ruby/tty-screen-0.5*
	=dev-ruby/unicode-display_width-1.1*
	=dev-ruby/verse-0.5*'

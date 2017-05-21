# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Terminal strings styling with intuitive and clean API."
HOMEPAGE="https://github.com/peter-murach/pastel"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

ruby_add_rdepend '
	=dev-ruby/equatable-0.5*
	=dev-ruby/tty-color-0.4*'

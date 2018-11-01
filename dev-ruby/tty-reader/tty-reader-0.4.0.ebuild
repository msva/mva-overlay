# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A set of methods for processing keyboard input"
HOMEPAGE="https://rubygems.org/gems/tty-reader"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

ruby_add_rdepend '
	=dev-ruby/tty-cursor-0.6*
	=dev-ruby/tty-screen-0.6*
	=dev-ruby/wisper-2.0*
'

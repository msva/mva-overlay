# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Terminal color capabilities detection"
HOMEPAGE="http://peter-murach.github.io/tty"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

ruby_add_rdepend '
	=dev-ruby/strings-ansi-0.1*
	=dev-ruby/unicode_utils-1.4*
	=dev-ruby/unicode-display_width-1.4*
'

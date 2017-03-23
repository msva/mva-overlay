# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Text transformations such as truncation, wrapping, aligning, indentation and "
HOMEPAGE="https://github.com/peter-murach/verse"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

ruby_add_rdepend '
	=dev-ruby/unicode_utils-1.4*'

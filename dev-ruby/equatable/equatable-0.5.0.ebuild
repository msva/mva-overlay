# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Allows ruby objects to implement equality comparison and inspection methods. "
HOMEPAGE="http://github.com/peter-murach/equatable"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

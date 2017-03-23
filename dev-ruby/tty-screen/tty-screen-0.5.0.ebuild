# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Terminal screen size detection which works on Linux, OS X and Windows/Cygwin "
HOMEPAGE="http://peter-murach.github.io/tty/"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm"

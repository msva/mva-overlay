# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Hirb provides a view framework for console applications, designed to improve irb's default output."
HOMEPAGE="http://github.com/cldwalker/hirb/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Tests depend on context (available, not added yet) and matchy (not
# available as a gem). And now also on mocha-on-bacon.
RESTRICT="test"

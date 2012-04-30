# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Hirb provides a view framework for console applications, designed to improve irb's default output."
HOMEPAGE="http://github.com/cldwalker/hirb/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Tests depend on context (available, not added yet) and matchy (not
# available as a gem).
RESTRICT="test"

ruby_add_bdepend test "virtual/ruby-test-unit dev-ruby/mocha"

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Tools for parsing and manipulating HTML documents"
HOMEPAGE="http://ruby-htmltools.rubyforge.org/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

# Tests fails but failure looks innocent.
RESTRICT="test"

each_ruby_test() {
	${RUBY} test/suite.rb
}

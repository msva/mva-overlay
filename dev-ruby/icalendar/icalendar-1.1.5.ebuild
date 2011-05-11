# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This library provides iCalendar support for ruby. (RFC-2445)"
HOMEPAGE="http://icalendar.rubyforge.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_bdepend test virtual/ruby-test-unit

all_ruby_prepare() {
	sed -i '/newgem/d' Rakefile || die
}

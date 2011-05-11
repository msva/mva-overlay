# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Manage delta indexes via datetime columns for Thinking Sphinx."
HOMEPAGE="http://freelancing-god.github.com/ts/en/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec )"

ruby_add_rdepend ">=dev-ruby/thinking-sphinx-1.3.8"

# There are also features but they require a live database.
each_ruby_test() {
	${RUBY} -S spec spec || die
}

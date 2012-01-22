# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18"

inherit ruby-fakegem

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

DESCRIPTION="A set of strategies for cleaning your database in Ruby."
HOMEPAGE="http://github.com/bmabey/database_cleaner"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

# Tests now require mongo_mapper which is not packaged yet.
RESTRICT="test"

ruby_add_bdepend test "dev-ruby/rake dev-ruby/rspec dev-util/cucumber"

each_ruby_prepare() {
	rm -rf spec/database_cleaner/couch_potato
}

each_ruby_test() {
	rake spec
}

all_ruby_install() {
	dodoc History.txt README.textile
}

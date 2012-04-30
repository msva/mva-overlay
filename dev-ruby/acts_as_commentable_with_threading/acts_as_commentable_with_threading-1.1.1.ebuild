# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18 ree18"

inherit ruby-fakegem

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

DESCRIPTION="Capabilities for smth."
HOMEPAGE="http://rake.rubyforge.org/"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="MIT"
DEPEND="
	dev-ruby/activesupport:3.0
	dev-ruby/activerecord:3.0
	dev-ruby/bundler
	dev-ruby/rake
	dev-ruby/rails:3.0
	dev-ruby/rspec:0
	dev-ruby/sqlite3-ruby
	dev-ruby/moretea-awesome_nested_set
"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

each_ruby_test() {
	${RUBY} test/list_test.rb
}

#all_ruby_install() {
#	dodoc README
#}

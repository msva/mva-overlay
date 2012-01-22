# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A clean, simple, and unobtrusive ruby authentication solution."
HOMEPAGE="http://authlogic.rubyforge.org/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_rdepend dev-ruby/activesupport
ruby_add_bdepend "test? ( dev-ruby/ruby-debug )"

# This approach makes it possible to ignore jeweler.
each_ruby_test() {
	${RUBY} -rtest/unit -e "Dir['test/**/*_test.rb'].each{|f| require f}" || die
}

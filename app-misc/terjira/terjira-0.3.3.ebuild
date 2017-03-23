# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Intercative JIRA cli"
HOMEPAGE="https://github.com/sumoheavy/jira-ruby https://rubygems.org/gems/jira-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+console"

ruby_add_rdepend "dev-ruby/activesupport:4.0
	=dev-ruby/jira-ruby-1.1*
	=dev-ruby/thor-0.19*
	=dev-ruby/tty-prompt-0.9*
	=dev-ruby/tty-spinner-0.4*
	=dev-ruby/tty-table-0.6*
	console? ( =dev-ruby/pry-0.10* )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${PN}.gemspec || die

	rm bin/{setup,terjira}
	# ^ bundler crap

	use console &&
	mv bin/{,jira-}console ||
	rm bin/console

#	mv bin/{,ter}jira
}

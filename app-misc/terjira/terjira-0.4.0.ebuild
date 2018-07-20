# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23"
# ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Intercative JIRA cli"
HOMEPAGE="https://github.com/keepcosmos/terjira https://rubygems.org/gems/terjira"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+console"

#ruby_add_rdepend "=dev-ruby/activesupport-4.1.11"
ruby_add_rdepend "~dev-ruby/jira-ruby-1.5.0"
ruby_add_rdepend "=dev-ruby/thor-0.19*"
ruby_add_rdepend "=dev-ruby/tty-prompt-0.12*"
ruby_add_rdepend "=dev-ruby/tty-spinner-0.4*"
ruby_add_rdepend "=dev-ruby/tty-table-0.8*"
ruby_add_rdepend "console? ( dev-ruby/pry )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${PN}.gemspec || die

	rm bin/{setup,terjira}
	# ^ bundler crap

	use console &&
	mv bin/{,jira-}console ||
	rm bin/console

#	mv bin/{,ter}jira
}

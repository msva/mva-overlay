# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24"
# ruby25"
# ^ thor

inherit ruby-fakegem git-r3

DESCRIPTION="Intercative JIRA cli"
HOMEPAGE="https://github.com/keepcosmos/terjira https://rubygems.org/gems/terjira"

SRC_URI=""
KEYWORDS=""

EGIT_REPO_URI="https://github.com/keepcosmos/terjira"
EGIT_CHECKOUT_DIR="${WORKDIR}/all"

LICENSE="MIT"
SLOT="0"
IUSE=""
#IUSE="+console"

#ruby_add_rdepend "dev-ruby/activesupport:4.11"
ruby_add_rdepend "~dev-ruby/jira-ruby-1.5.0"
ruby_add_rdepend "=dev-ruby/thor-0.19*"
ruby_add_rdepend "=dev-ruby/tty-prompt-0.17*"
ruby_add_rdepend "=dev-ruby/tty-spinner-0.4*"
ruby_add_rdepend "=dev-ruby/tty-table-0.10*"
#ruby_add_rdepend "console? ( dev-ruby/pry )"
#	console? ( =dev-ruby/pry-0.10* )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${PN}.gemspec || die

	rm bin/{setup,terjira,console}
	# ^ bundler crap

#	use console &&
#	mv bin/{,jira-}console ||
#	rm bin/console
}

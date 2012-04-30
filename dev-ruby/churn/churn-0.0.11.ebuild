# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A Project to give the churn file, class, and method for a project for a given checkin."
HOMEPAGE="http://metric-fu.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend ">=dev-ruby/mocha-0.9.5
	dev-ruby/test-construct
	dev-ruby/shoulda"

ruby_add_rdepend "dev-ruby/main
	dev-ruby/json
	dev-ruby/chronic
	dev-ruby/sexp-processor
	dev-ruby/ruby_parser
	dev-ruby/hirb"

each_ruby_prepare() {
	sed -i '/check_dependencies/d' Rakefile || die "Unable to remove check_dependencies dependency."
}

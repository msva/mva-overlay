# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="Ruby gem that provides an AR-style interface for the Pivotal Tracker API."
HOMEPAGE="http://github.com/jsmestad/pivotal-tracker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Specs depend on http://github.com/jsmestad/stale_fish which is not
# packaged yet.
RESTRICT="test"

ruby_add_bdepend doc dev-ruby/yard

ruby_add_rdepend ">=dev-ruby/rest-client-1.4.1
	>=dev-ruby/nokogiri-1.4.1
	>=dev-ruby/happymapper-0.2.4
	dev-ruby/builder"

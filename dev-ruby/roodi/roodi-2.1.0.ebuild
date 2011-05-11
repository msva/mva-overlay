# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="Roodi stands for Ruby Object Oriented Design Inferometer"
HOMEPAGE="http://rubyforge.org/projects/roodi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend dev-ruby/ruby_parser

ruby_add_bdepend doc "dev-ruby/hoe dev-ruby/rdoc"
ruby_add_bdepend test "dev-ruby/hoe dev-ruby/rspec"

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_newins roodi.yml roodi.yml
}

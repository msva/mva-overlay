# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_EXTRAINSTALL="rails_best_practices.yml"

inherit ruby-fakegem

DESCRIPTION="a gem to check quality of rails app files"
HOMEPAGE="http://wiki.github.com/flyerhzm/rails_best_practices"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/README/README.textile/' Rakefile
}

ruby_add_bdepend "test? ( dev-ruby/rspec )"

ruby_add_rdepend ">=dev-ruby/ruby2ruby-1.2.4 >=dev-ruby/ruby_parser-2.0.4"

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="An ActiveRecord library to add before_commit, after_commit, before_rollback and after_rollback callbacks."
HOMEPAGE="http://freelancing-gods.com/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_rdepend dev-ruby/activerecord

each_ruby_test() {
	${RUBY} -Ctest -e "Dir['*_test.rb'].each{|f| require f}"
}

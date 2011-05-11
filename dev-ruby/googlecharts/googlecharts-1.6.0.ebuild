# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: NEEDS MAINTAINER!!!! $

EAPI="3"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.txt README.markdown"
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="The goal of this Gem is to make the creation of Google Charts a simple and easy task."
HOMEPAGE="http://googlecharts.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rspec )"

each_ruby_test() {
	${RUBY} -S spec spec
}

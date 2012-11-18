# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"
USE_RUBY="ruby18 ree18 ruby19"

inherit ruby-fakegem

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

DESCRIPTION="Capabilities for smth."
HOMEPAGE="http://rake.rubyforge.org/"
SRC_URI="mirror://rubygems/${P//_/-}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

each_ruby_test() {
	${RUBY} test/list_test.rb
}

#all_ruby_install() {
#	dodoc README
#}

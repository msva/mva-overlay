# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"
RUBY_FAKEGEM_EXTRAINSTALL="init.rb generators"

inherit ruby-fakegem

DESCRIPTION="This library dynamically replace net/smtp and net/pop with these in ruby 1.9, thus enabling SSL/TLS."
HOMEPAGE="http://rubyforge.org/projects/tlsmail/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "doc? ( dev-ruby/hoe )"
ruby_add_bdepend "test? ( dev-ruby/hoe virtual/ruby-test-unit dev-ruby/flexmock )"

each_ruby_test() {
	${RUBY} -Ilib test/test_calendar_helper.rb || die
}

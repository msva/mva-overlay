# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="The ReCaptchaClient abstracts the ReCaptcha API for use in Rails Applications"
HOMEPAGE="http://www.bitbucket.org/mml/ruby-recaptcha"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( virtual/ruby-test-unit dev-ruby/mocha dev-ruby/rails )"

each_ruby_test() {
	${RUBY} test/test_recaptcha.rb || die
}

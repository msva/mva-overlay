# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="A Ruby binding to the password strength checker, libcrack/cracklib."
HOMEPAGE="http://rubyforge.org/projects/rubylibcrack/"
LICENSE="GPL-3"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_bdepend test virtual/ruby-test-unit

each_ruby_configure() {
	pushd ext
	${RUBY} extconf.rb || die
	popd
}

each_ruby_compile() {
	pushd ext
	emake || die
	popd
}

each_ruby_test() {
	${RUBY} test/test_rubylibcrack.rb
}

each_ruby_install() {
	mkdir lib || die
	mv ext/rubylibcrack.so lib || die

	each_fakegem_install
}

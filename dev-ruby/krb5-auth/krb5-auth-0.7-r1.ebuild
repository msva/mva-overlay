# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README TODO example.rb"

RUBY_FAKEGEM_TASK_TEST=""

inherit multilib ruby-fakegem

DESCRIPTION="Ruby bindings for the Kerberos library"
HOMEPAGE="http://rubyforge.org/projects/krb5-auth/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} virtual/krb5"
RDEPEND="${RDEPEND} virtual/krb5"

all_ruby_prepare() {
	# Move the example out of the bin directory to avoid auto-installation
	mv bin/example.rb . || die
	rmdir bin || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	# We have injected --no-undefined in Ruby as a safety precaution
	# against broken ebuilds, but these bindings unfortunately rely on
	# a symbol that cannot be linked directly.
	find . -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-Wl,--no-undefined::' || die "--no-undefined removal failed"

	emake -Cext || die
	mkdir lib || die
	cp ext/*$(get_modname) lib/ || die
}

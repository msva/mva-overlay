# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

MY_PV=${PV//./_}
DESCRIPTION="Implementation of a Ruby binding to Apple's cross-platform multicast DNS Service Discovery API."
HOMEPAGE="http://rubyforge.org/projects/dnssd/"
LICENSE="Ruby"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

# Tests depend on a specific service which is not available.
RESTRICT="test"

DEPEND="net-dns/avahi[mdnsresponder-compat]"
RDEPEND=${DEPEND}

ruby_add_bdepend ">=dev-ruby/hoe-2.3.3 >=dev-ruby/rake-compiler-0.6"

each_ruby_configure() {
	pushd ext/dnssd &> /dev/null
	${RUBY} extconf.rb || die "Unable to configure the extension."
	popd &> /dev/null
}

each_ruby_compile() {
	pushd ext/dnssd &> /dev/null
	emake
	popd &> /dev/null
}

each_ruby_install() {
	mv ext/dnssd/dnssd.so lib || die "Unable to move extension to lib."
	each_fakegem_install
}

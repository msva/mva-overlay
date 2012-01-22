# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/tzinfo/tzinfo-0.3.30.ebuild,v 1.1 2011/09/29 23:28:45 flameeyes Exp $

EAPI=2
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES README"

inherit ruby-fakegem

DESCRIPTION="Daylight-savings aware timezone library"
HOMEPAGE="http://tzinfo.rubyforge.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND=""

ruby_add_bdepend "test? ( virtual/ruby-test-unit )"

all_ruby_prepare() {
	# With rubygems 1.3.1 we get the following warning
	# warning: Insecure world writable dir /var/tmp in LOAD_PATH, mode 041777
	# when running the test_get_tainted_not_loaded test.
	sed -i \
		-e '/^    def test_get_tainted_not_loaded/, /^    end/ s:^:#:' \
		"${S}"/test/tc_timezone.rb || die "unable to sed out the test"
}

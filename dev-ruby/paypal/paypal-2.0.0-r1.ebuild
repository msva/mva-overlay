# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2
USE_RUBY="ruby18"

inherit ruby-fakegem

DESCRIPTION="Library aiding with Paypal IPN from web applications."
HOMEPAGE="http://rubyforge.org/projects/paypal/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~ia64 ~x86"
SLOT="0"
IUSE=""

# Tests don't work
RESTRICT="test"

ruby_add_rdepend "dev-ruby/money"

all_ruby_install() {
	all_fakegem_install

	dodoc misc/* || die
}

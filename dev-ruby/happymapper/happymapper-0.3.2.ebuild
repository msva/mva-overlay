# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="Object to xml mapping library."
HOMEPAGE="http://github.com/jnunemaker/happymapper/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec )"
ruby_add_rdepend ">=dev-ruby/libxml-1.1.3"

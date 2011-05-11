# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="API.txt History.txt README.md"

# No convenient way to run tests so check that out later.
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Grit gives you object oriented read/write access to Git repositories via Ruby."
HOMEPAGE="http://github.com/mojombo/grit"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend test "dev-ruby/mocha virtual/ruby-test-unit"

ruby_add_rdepend ">=dev-ruby/mime-types-1.15 >=dev-ruby/diff-lcs-1.1.2"

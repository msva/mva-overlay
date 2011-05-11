# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README TODO docs/Changes docs/Roadmap"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Ruby Simple Indexer (or perhaps Really Simple Indexer) is a simple full text index."
HOMEPAGE="http://rsi.rubyforge.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RUBY_PATCHES=( "${P}-fix-logger.patch" )

ruby_add_rdepend "dev-ruby/ruby-bz2"

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/* || die "Tests failed."
}

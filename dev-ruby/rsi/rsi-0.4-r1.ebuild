# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
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

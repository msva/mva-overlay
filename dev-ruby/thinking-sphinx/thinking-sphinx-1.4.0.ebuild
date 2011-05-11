# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_EXTRAINSTALL="rails"

inherit ruby-fakegem

DESCRIPTION="A concise and easy-to-use Ruby library that connects ActiveRecord to the Sphinx search daemon."
HOMEPAGE="http://freelancing-god.github.com/ts/en/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activerecord-1.15.6
	>=dev-ruby/riddle-1.0.10
	>=dev-ruby/after_commit-1.0.6"

# There are specs and features but not all files are present so they
# don't run.

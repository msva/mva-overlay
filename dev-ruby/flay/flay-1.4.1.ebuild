# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Flay analyzes code for structural similarities."
HOMEPAGE="http://ruby.sadi.st/"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "=dev-ruby/sexp-processor-3.0* =dev-ruby/ruby_parser-2.0*"

ruby_add_bdepend "doc? ( dev-ruby/hoe )"
ruby_add_bdepend "test? ( dev-ruby/hoe virtual/ruby-minitest )"

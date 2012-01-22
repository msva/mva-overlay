# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A wrapper to support colored output with test/unit."
HOMEPAGE="http://on-ruby.blogspot.com/2006/05/red-and-green-for-ruby.html"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

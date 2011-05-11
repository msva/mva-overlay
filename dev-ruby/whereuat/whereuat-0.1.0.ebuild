# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRAINSTALL="assets dev Rakefile"

inherit ruby-fakegem

DESCRIPTION="Adds a slide out panel to your rails app that directs clients to test stories."
HOMEPAGE="https://github.com/plus2/whereuat"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/haml-2.2.0
	>=dev-ruby/pivotal-tracker-0.1.3
	>=dev-ruby/rack-1.0.0"

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

# Not distributed in the gem.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="Extension of the Authlogic library to add OpenID support."
HOMEPAGE="http://authlogic-oid.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/oauth-0.4.1
	>=dev-ruby/json-1.1.9
	>=dev-ruby/mime-types-1.16"

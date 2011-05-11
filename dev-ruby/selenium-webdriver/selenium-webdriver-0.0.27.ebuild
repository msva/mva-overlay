# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

# NOTE: this package contains precompiled code. If we ever move this
# to the official repository we should find all the source code and
# compile the right extension on the fly.

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver."
HOMEPAGE="http://gemcutter.org/gems/selenium-webdriver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ffi-0.6.1
	dev-ruby/json
	dev-ruby/rubyzip"

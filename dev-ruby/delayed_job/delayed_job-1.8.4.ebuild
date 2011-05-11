# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI=2

USE_RUBY="ruby18"

# Requires Jeweler
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.textile"
RUBY_FAKEGEM_EXTRAINSTALL="generators recipes tasks"

inherit ruby-fakegem

DESCRIPTION="Delated_job encapsulates the common pattern of asynchronously executing longer tasks in the background."
HOMEPAGE="http://github.com/tobi/delayed_job"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend test dev-ruby/rspec

each_ruby_test() {
	${RUBY} -S spec spec
}

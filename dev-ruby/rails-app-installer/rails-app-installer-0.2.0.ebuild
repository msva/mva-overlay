# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="This is an installer for Rails applications."
HOMEPAGE="http://typosphere.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc"

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/examples
	doins examples/* || die
}

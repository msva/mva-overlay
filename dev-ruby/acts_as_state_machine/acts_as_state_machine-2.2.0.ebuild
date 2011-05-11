# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rake/rake-0.8.7-r2.ebuild,v 1.2 2009/12/15 06:54:12 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

# Uses syntax that no longer works with current rdoc
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README TODO"

# Uses obsolete activerecord syntax and no longer works.
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="This act gives an Active Record model the ability to act as a finite state machine (FSM)."
HOMEPAGE="http://rake.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activerecord-2.1"

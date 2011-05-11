# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="init.rb rails rails_generators script"

# There are specs and features, but the specs only work with JRuby
# (?!) and the features seem to depend on an outdated cucumber and
# fail due to ambiguous matches.
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Culerity integrates Cucumber and Celerity in order to test your application's full stack."
HOMEPAGE="http://celerity.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#ruby_add_bdepend "test? ( dev-util/cucumber )"

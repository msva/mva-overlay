# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.markdown"

inherit ruby-fakegem

DESCRIPTION="Geokit provides geocoding and distance calculation in an easy-to-use API."
HOMEPAGE="http://geokit.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Some tests fail, skip for now.
RESTRICT="test"

ruby_add_bdepend dev-ruby/hoe

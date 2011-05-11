# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="HISTORY README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Sanitize is a whitelist-based HTML sanitizer."
HOMEPAGE="http://github.com/rgrove/sanitize"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.1"

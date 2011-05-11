# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mislav-will_paginate/mislav-will_paginate-2.3.11.ebuild,v 1.1 2009/06/08 20:44:54 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRAINSTALL="rails"

inherit ruby-fakegem

DESCRIPTION="This package adds full support for embedding inline images into HTML emails through ActionMailer."
HOMEPAGE="https://github.com/JasonKing/inline_attachement"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

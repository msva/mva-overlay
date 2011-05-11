# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rmagick/rmagick-1.15.8.ebuild,v 1.1 2007/08/04 06:54:34 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRA_DOC="README"

inherit ruby-fakegem

DESCRIPTION="A Ruby cyclomatic complexity analyzer."
HOMEPAGE="http://saikuro.rubyforge.org/"
SRC_URI="mirror://rubygems/Saikuro-${PV}.gem"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/saikuro"


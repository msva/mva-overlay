# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
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

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRAINSTALL="assets dev Rakefile"

inherit ruby-fakegem

DESCRIPTION="Adds a slide out panel to your rails app that directs clients to test stories."
HOMEPAGE="https://github.com/plus2/whereuat"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/haml-2.2.0
	>=dev-ruby/pivotal-tracker-0.1.3
	>=dev-ruby/rack-1.0.0"

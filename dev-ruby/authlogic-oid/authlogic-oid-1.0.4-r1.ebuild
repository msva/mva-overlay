# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

inherit ruby-fakegem

DESCRIPTION="Extension of the Authlogic library to add OpenID support."
HOMEPAGE="http://authlogic-oid.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

# Tests use hardcoded path to authlogic
RESTRICT="test"

ruby_add_bdepend "doc? ( dev-ruby/hoe )"

ruby_add_rdepend ">=dev-ruby/authlogic-2.0.13"

all_ruby_prepare() {
	# Remove reference to documenation template we don't have.
	sed -i -e 's/-T hanna//' Rakefile || die
}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/oauth/oauth-0.4.3.ebuild,v 1.1 2010/09/18 09:58:03 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="generators init.rb rails tasks"

inherit ruby-fakegem

DESCRIPTION="A plugin for implementing OAuth Providers and Consumers in Rails applications."
HOMEPAGE="http://github.com/pelle/oauth-plugin"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/oauth-0.3.5"

all_ruby_prepare() {
	sed -i -e "s/README/README.rdoc/" Rakefile || die
}

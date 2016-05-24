# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

EGIT_REPO_URI="https://github.com/mpalmer/lvmsync"
EGIT_CHECKOUT_DIR="${WORKDIR}/all"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKGEM_GESPEC="${PN}.gemspec"

inherit ruby-fakegem git-r3

SRC_URI=""

DESCRIPTION="Synchronise LVM LVs across a network by sending only snapshotted changes"
HOMEPAGE="http://theshed.hezmatt.org/lvmsync"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE=""

ruby_add_bdepend "dev-ruby/rake"

all_ruby_install() {
	all_fakegem_install
	dodoc README.md
}

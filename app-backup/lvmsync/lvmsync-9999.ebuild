# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26"

EGIT_REPO_URI="https://github.com/mpalmer/lvmsync"
EGIT_CHECKOUT_DIR="${WORKDIR}/all"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKGEM_GESPEC="${PN}.gemspec"

inherit ruby-fakegem git-r3

DESCRIPTION="Synchronise LVM LVs across a network by sending only snapshotted changes"
HOMEPAGE="http://theshed.hezmatt.org/lvmsync"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

ruby_add_bdepend "dev-ruby/rake"
ruby_add_rdepend "dev-ruby/treetop"
ruby_add_rdepend "dev-ruby/git-version-bump"

all_ruby_install() {
	all_fakegem_install
	dodoc README.md
}

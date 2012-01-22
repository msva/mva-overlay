# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

USE_RUBY="ruby18"

# Requires Jeweler
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.textile"
RUBY_FAKEGEM_EXTRAINSTALL="generators rails recipes tasks"

inherit ruby-fakegem

DESCRIPTION="Encapsulates the common pattern of executing longer tasks in the background."
HOMEPAGE="http://github.com/tobi/delayed_job"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

# Needs dm-core which we don't have packaged yet.
RESTRICT="test"

ruby_add_bdepend "test? ( dev-ruby/rspec )"

each_ruby_test() {
	${RUBY} -S spec spec || die "Tests failed."
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

inherit ruby-fakegem

DESCRIPTION="manpages wrapper for rubygems"
HOMEPAGE="https://github.com/bitboxer/manpages"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

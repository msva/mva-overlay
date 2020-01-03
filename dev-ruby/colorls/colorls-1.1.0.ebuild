# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RUBY_FAKEGEM_EXTRAINSTALL="zsh"
RUBY_FAKEGEM_BINDIR="exe"

USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="A Ruby script that colorizes the ls output with color and icons"
HOMEPAGE="https://github.com/athityakumar/colorls"
LICENSE="MIT"

RESTRICT="test"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~arm   - missing in rainbow
# ~arm64 - missing everywhere
# 2019: still the issue...

ruby_add_rdepend '
	dev-ruby/filesize:*
	dev-ruby/rainbow:3
	dev-ruby/clocale
	dev-ruby/manpages
'

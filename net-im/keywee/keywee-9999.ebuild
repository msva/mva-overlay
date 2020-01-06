# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit haskell-cabal git-r3 patches

DESCRIPTION="WeeChat plugin for Keybase chat"
HOMEPAGE="https://github.com/jkopanski/keywee"
EGIT_REPO_URI="https://github.com/jkopanski/keywee"

LICENSE="GPL-3"
SLOT="0"

#BDEPEND="
#	>=dev-haskell/async-2.1
#	>=dev-haskell/conduit-1.2
##	dev-haskell/conduit-combinators
#	>=dev-haskell/conduit-extra-1.1
#	dev-haskell/lens
#	=dev-haskell/monads-tf-0.1*
#	=dev-haskell/mono-traversable-1.0*
##	dev-haskell/reactive-banana
##	dev-haskell/rio
#	<dev-haskell/stm-2.6
##	dev-haskell/stm-conduit
#"
#RDEPEND="${BDEPEND}"
pkg_pretend() {
	die "Not yet ready"
}

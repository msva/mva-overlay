# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit git-2
DESCRIPTION="Programmable Completion for zsh (includes emerge and ebuild commands)"
HOMEPAGE="http://gentoo.org"
EGIT_REPO_URI="git://github.com/zsh-users/zsh-completions"

LICENSE="ZSH"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-shells/zsh"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/zsh/site-functions
	doins _*

	dodoc README.md
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make zsh-completion available"
	elog "to your shell."
	elog
}

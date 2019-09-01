# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 vim-plugin

DESCRIPTION="vim plugin: 010 Editor template interpreter"
HOMEPAGE="https://github.com/d0c-s4vage/pfp-vim"
LICENSE="MIT"
KEYWORDS=""
IUSE=""

EGIT_REPO_URI="https://github.com/d0c-s4vage/pfp-vim"

DEPEND="
	dev-python/pfp
	app-misc/010-editor-templates
"

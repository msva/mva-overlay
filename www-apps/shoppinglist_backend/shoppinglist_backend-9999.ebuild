# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Backend for a Android based app called ShoppingList"
HOMEPAGE="https://github.com/GroundApps/ShoppingList_backend"
EGIT_REPO_URI="https://github.com/GroundApps/ShoppingList_backend.git"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT=0

RDEPEND="virtual/httpd-php"

src_install() {
	default

	rm README.md LICENSE CONTRIBUTING.md

	insinto "/usr/share/${PN}"
	doins -r *
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r1 eutils

DESCRIPTION="WebDAV stream wrapper class"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="
	dev-lang/php
	dev-php/PEAR-HTTP_Request
"

src_prepare() {
	epatch "${FILESDIR}/fix-propfind-response-parser.patch"
}

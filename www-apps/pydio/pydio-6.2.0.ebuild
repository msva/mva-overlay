# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="File sharing platform similar to dropbox"
HOMEPAGE="https://pyd.io/"
SRC_URI="http://sourceforge.net/projects/ajaxplorer/files/${PN}/stable-channel/${PV}/${PN}-core-${PV}.tar.gz/download -> ${P}.tar.gz"
RESTRICTION="mirror"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="+webdav"
SLOT=0

DEPEND="
	webdav? ( dev-php/PEAR-HTTP_WebDAV_Client )
	virtual/httpd-php:*
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-core-${PV}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *

	dodoc "${FILESDIR}/${PV}".mysql
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luarocks/luarocks-1.0.ebuild,v 1.1 2010/11/05 22:13:24 rafaelmartins Exp $

EAPI=4

inherit eutils git-2

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"
EGIT_REPO_URI="git://github.com/keplerproject/luarocks.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="curl openssl"

DEPEND="dev-lang/lua
		curl? ( net-misc/curl )
		openssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
		app-arch/unzip"

#### sorry for that, but luarocks make fails if -j is >= 3
MAKEOPTS="-j2"

src_configure() {
	USE_MD5="md5sum"
	USE_FETCH="wget"
	use openssl && USE_MD5="openssl"
	use curl && USE_FETCH="curl"

	# econf doesn't work b/c it passes variables the custom configure can't
	# handle
	./configure \
			--prefix=/usr \
			--with-lua=/usr \
			--with-lua-lib=/usr/$(get_libdir) \
			--rocks-tree=/usr/lib/lua/luarocks \
			--with-downloader=$USE_FETCH \
			--with-md5-checker=$USE_MD5 \
			--force-config || die "configure failed"
}

src_compile() {
        emake -j1 DESTDIR="${D}" || die "make failed"
}

src_install() {
        emake -j1 DESTDIR="${D}" install || die "einstall"
}

pkg_preinst() {
	find "${D}" -type f | xargs sed -i -e "s:${D}::g" || die "sed failed"
}

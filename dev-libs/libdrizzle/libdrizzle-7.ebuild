# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="drizzle7-2011.07.21"

inherit eutils multilib-minimal

DESCRIPTION="Snapshot of dev-db/drizzle sources which can be built as shared library"
HOMEPAGE="https://github.com/openresty/drizzle-nginx-module"
SRC_URI="http://agentzh.org/misc/nginx/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
#	sed -r \
#		-e '/^PREFIX=/s@(PREFIX)=.*@\1=/usr@' \
#		-e '/^INSTALL_LIB/s@lib@$(LIBDIR_${ABI})@' \
#		-i Makefile
	sed -r \
	-e 's|python (config/pandora-plugin)|python2 \1|' \
	-i Makefile.in
	eapply_user
	multilib_copy_sources
}

multilib_src_configure() {
	econf --without-server
}

multilib_src_compile() {
	emake libdrizzle-1.0
}

multilib_src_install() {
	emake DESTDIR="${D}" install-libdrizzle-1.0
}

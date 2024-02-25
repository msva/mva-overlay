# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="drizzle7-2011.07.21"

inherit multilib-minimal

DESCRIPTION="Snapshot of dev-db/drizzle sources which can be built as shared library"
HOMEPAGE="https://github.com/openresty/drizzle-nginx-module"
SRC_URI="https://openresty.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -r \
	-e 's|python (config/pandora-plugin)|python2 \1|' \
	-i Makefile.in
	default
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

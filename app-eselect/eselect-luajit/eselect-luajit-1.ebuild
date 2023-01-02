# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages LuaJIT symlinks"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=app-admin/eselect-1.2.3
"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/luajit-${PV}.eselect" luajit.eselect || die "newins failed"
}

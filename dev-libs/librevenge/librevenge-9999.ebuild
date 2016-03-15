# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils git-r3 multilib multilib-minimal autotools-utils

DESCRIPTION="A helper library for REVerses ENGineered formats filters"
HOMEPAGE="http://sf.net/p/libwpd/librevenge"
EGIT_REPO_URI="git://git.code.sf.net/p/libwpd/librevenge"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc"

RDEPEND=""
DEPEND="
	${RDEPEND}
	sys-libs/zlib
"
RDEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF=yes

src_configure() {
	myeconfargs=(
		"--disable-static"
		"--disable-werror"
		"$(use_with doc docs)"
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --all
}

#pkg_postinst() {
#	if use tools; then
#		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-9]"
#	fi
#}
#
#pkg_postrm() {
#	if use tools; then
#		alternatives_auto_makesym /usr/bin/wpd2html "/usr/bin/wpd2html-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2raw "/usr/bin/wpd2raw-[0-9].[0-9]"
#		alternatives_auto_makesym /usr/bin/wpd2text "/usr/bin/wpd2text-[0-9].[0-9]"
#	fi
#}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs flag-o-matic eutils subversion

DESCRIPTION="DBI module for Lua"
HOMEPAGE="http://code.google.com/p/luadbi/"
ESVN_REPO_URI="http://luadbi.googlecode.com/svn/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="mysql postgres sqlite"

RDEPEND=">=dev-lang/lua-5.1
		mysql? ( dev-db/mysql )
		postgres? ( dev-db/postgresql-base )
		sqlite? ( >=dev-db/sqlite-3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-Makefile.patch"
	epatch "${FILESDIR}/${PV}-postgres-path.patch"
	sed -i -e "s#^INSTALL_DIR_LUA=.*#INSTALL_DIR_LUA=$(pkg-config --variable INSTALL_LMOD lua)#" "${S}/Makefile"
	sed -i -e "s#^INSTALL_DIR_BIN=.*#INSTALL_DIR_BIN=$(pkg-config --variable INSTALL_CMOD lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_INC_DIR=.*#LUA_INC_DIR=$(pkg-config --variable INSTALL_INC lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_LIB_DIR=.*#LUA_LIB_DIR=$(pkg-config --variable INSTALL_LIB lua)#" "${S}/Makefile"
	sed -i -e "s#^LUA_LIB =.*#LUA_LIB=lua#" "${S}/Makefile"
}

src_compile() {
	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	if [ -z "${drivers// /}" ] ; then
		eerror
		eerror "No driver was selected, cannot build."
		eerror "Please set USE flags to build any driver."
		eerror "Possible USE flags: mysql postgres sqlite"
		eerror
		die "No driver selected"
	fi

	append-flags -fPIC -c
	for driver in "${drivers}" ; do
		emake ${driver} \
			|| die "Compiling driver '${drivers// /}' failed"
	done
}

src_install() {
	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	for driver in ${drivers} ; do
		emake DESTDIR="${D}" "install_${driver// /}" \
			|| die "Install of driver '${drivers// /}' failed"
	done
}

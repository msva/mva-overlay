# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="lua51 luajit2"
IS_MULTILIB=true
VCS="mercurial"
BITBUCKET_A="mva"
BITBUCKET_PN="${PN}-temp"
inherit lua

DESCRIPTION="DBI module for Lua"
HOMEPAGE="https://code.google.com/p/luadbi"
#EHG_REPO_URI="https://code.google.com/p/luadbi"
#EHG_REPO_URI="https://bitbucket.org/mva/luadbi-temp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="mysql postgres sqlite oracle"

RDEPEND="
	mysql? ( || ( dev-db/mysql dev-db/mariadb ) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3 )
	oracle? ( dev-db/oracle-instantclient-basic )
"
DEPEND="${RDEPEND}"

#S="${WORKDIR}"

each_lua_compile() {
	local drivers=()
	use mysql && drivers+=( "mysql" )
	use postgres && drivers+=( "psql" )
	use sqlite && drivers+=( "sqlite3" )
	use oracle && drivers+=( "oracle" )

	if [[ -z "${drivers[@]}" ]] ; then
		eerror
		eerror "No driver was selected, cannot build."
		eerror "Please set USE flags to build any driver."
		eerror "Possible USE flags: mysql postgres sqlite"
		eerror
		die "No driver selected"
	fi

	for driver in "${drivers[@]}"; do
		local buildme;
		if [[ ${driver} = "psql" && ${ABI} = "x86" ]] && use amd64; then
			# FIXME: when postgres and perl (as postgres dep) will have multilib support
			buildme=no
		fi

#			LUA_INC="$($(tc-getPKG_CONFIG) --cflags ${lua_impl})" \

		[[ ${buildme} = "no" ]] || lua_default \
			PSQL_INC="-I/usr/include/postgresql/server" \
			MYSQL_INC="-I/usr/include/mysql -L/usr/$(get_libdir)/mysql" \
			${driver}

		unset buildme
	done
}

each_lua_install() {
	local libs=();
	for lib in $(find . -name '*.so'); do
		libs+=(${lib})
	done
	[[ -z "${libs[@]}" ]] || dolua ${libs[@]}
	dolua DBI.lua
}

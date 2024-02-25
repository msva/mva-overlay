# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="DBI module for Lua"
HOMEPAGE="https://code.google.com/archive/p/luadbi"
EGIT_REPO_URI="https://github.com/mwild1/luadbi"

LICENSE="MIT"
SLOT="0"
IUSE="mysql postgres sqlite oracle"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	mysql? ( || ( dev-db/mysql dev-db/mariadb ) )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3 )
	oracle? ( dev-db/oracle-instantclient )
"
DEPEND="${RDEPEND}"

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
		pushd "${BUILD_DIR}"
		local myemakeopts=(
			CC=$(tc-getCC)
			LUA_INC="-I$(lua_get_include_dir)"
		)
		if [[ "${driver}" == "psql" ]]; then
			myemakeopts+=(PSQL_INC="-I/usr/include/postgresql/server")
		elif [[ "${driver}" == "mysql" ]]; then
			myemakeopts+=(MYSQL_INC="-I/usr/include/mysql")
			myemakeopts+=(MYSQL_LDFLAGS="-L/usr/$(get_libdir)/mysql -lmysqlclient")
		fi
		emake ${myemakeopts[@]} ${driver}
		popd
	done
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	for lib in $(find . -name '*.so'); do
		doins "${lib}"
	done
	insinto "$(lua_get_lmod_dir)"
	doins DBI.lua
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

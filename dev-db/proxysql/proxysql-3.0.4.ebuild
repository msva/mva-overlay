# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit git-r3

DESCRIPTION="A high performance, high availability, protocol aware proxy for MySQL and forks"
HOMEPAGE="https://www.proxysql.com"
LICENSE="GPL-3"
SLOT="0"

EGIT_REPO_URI="https://github.com/sysown/${PN}"
EGIT_COMMIT="v${PV}"

KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libev
	net-libs/libmicrohttpd
	dev-libs/libpcre
	dev-libs/re2
	net-misc/curl
	virtual/zlib
	>=virtual/mysql-5.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

# src_prepare() {
# 	cp "${FILESDIR}/deps.Makefile" deps/Makefile
# 	cp "${FILESDIR}/lib.Makefile"  lib/Makefile
# 	cp "${FILESDIR}/src.Makefile"  src/Makefile
# 	# TODO: support not only ~amd64. Blocker: ma_config.h
# 	# cp "${FILESDIR}/ma_global.h" "${FILESDIR}/ma_config.h" include/
# 	sed -r \
# 		-e '1i#include <mariadb_ctype.h>' \
# 		-e '1i#include <mariadb/mysql.h>' \
# 		-i lib/mysql_connection.cpp || die
#
# #	sed -r \
# #		-e '/ar rcs/{s@\$\(RE2_PATH\)/obj/libre2\.a@-lre2@;s@\$\(SQLITE3_DIR\)/sqlite3\.o@-lsqlite3@}' \
# #		-e '/libproxysql.a:/{s@\$\(RE2_PATH\)/obj/libre2\.a \$\(SQLITE3_DIR\)/sqlite3\.o@@}'
# #		-i lib/Makefile
# #
# 	default
# }
# # TODO: mariadb, re2 configure and take headers
# src_compile() {
# 	#emake -C deps
# 	emake -C lib
# 	emake -C src
# }

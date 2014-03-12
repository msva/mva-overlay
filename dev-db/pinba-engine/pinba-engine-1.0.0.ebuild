# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3
inherit autotools confutils eutils multilib
DESCRIPTION="Pinba is a MySQL storage engine that acts as a realtime monitoring/statistics server."
HOMEPAGE="http://pinba.org/"
SRC_URI="http://pinba.org/files/pinba_engine-${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""
DEPEND="dev-libs/protobuf
	dev-libs/judy
	>=dev-libs/libevent-1.4
	>=virtual/mysql-5.1"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/pinba_engine-${PV}

src_prepare() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_PACKAGE="$(best_version "dev-db/mysql" || best_version "dev-db/mariadb")"
	MYSQL_PACKAGE_VERSION="${MYSQL_PACKAGE##*/}"
	MYSQL_PACKAGE_PATH="${MYSQL_PACKAGE%%/*}/${MYSQL_PACKAGE_VERSION%%-*}/${MYSQL_PACKAGE_VERSION}"
	MYSQL_WORK="${PORTAGE_TMPDIR}/portage/${MYSQL_PACKAGE}/work"
	MYSQL_SOURCES="${MYSQL_WORK}/mysql"
	MYSQL_BUILD="${MYSQL_WORK}/${MYSQL_PACKAGE_VERSION}_build"

	if [[ ! -d "${MYSQL_BUILD}" ]]; then
		einfo "Compiling ${MYSQL_PACKAGE}"
		ebuild /usr/portage/${MYSQL_PACKAGE_PATH}.ebuild compile
	fi

	cp "${MYSQL_BUILD}"/include/*.h "${MYSQL_SOURCES}/include/"
}

src_configure() {
	econf --with-mysql=${MYSQL_SOURCES} \
		--with-judy \
		--with-protobuf \
		--with-event \
		--libdir=${MYSQL_PLUGINDIR}
}
src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodir /usr/share/pinba/
	insinto /usr/share/pinba/
	doins default_tables.sql
}

pkg_postinst() {
	einfo "You need to execute the following command on mysql server"
	einfo "so pinba works properly:"
	elog "mysql> INSTALL PLUGIN pinba SONAME 'libpinba_engine.so';"
	elog "mysql> CREATE DATABASE pinba;"
	elog "mysql -D pinba < /usr/share/pinba/default_tables.sql"
}

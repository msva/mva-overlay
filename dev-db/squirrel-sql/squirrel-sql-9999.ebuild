# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"
inherit eutils git-r3 java-pkg-2 java-ant-2

EGIT_REPO_URI="git://git.code.sf.net/p/squirrel-sql/git"
KEYWORDS=""
SRC_URI=""
SLOT="0"

IUSE="firebird informix mssql mysql oracle postgres sybase"

DEPEND=">=virtual/jdk-1.5"
RDEPEND="
	${DEPEND}
	dev-java/log4j
	postgres? ( dev-java/jdbc-postgresql )
	mysql? ( dev-java/jdbc-mysql )
	mssql? ( dev-java/jdbc-mssqlserver )
	sybase? ( dev-java/jtds )
	informix? ( dev-java/jdbc-informix )
	firebird? ( dev-java/jdbc-jaybird )
	oracle? ( dev-java/jdbc-oracle-bin )
"
#	viruoso? ( dev-db/virtuoso-jdbc )

S="${WORKDIR}/${P}/sql12"

EANT_BUILD_TARGET="cleanAllAndInit compileCore compileOptionalPlugins"

src_install() {
	cd ${S}/output/dist;
	local squirrel_dir="${EROOT}usr/share/${PN}";
	insinto "${squirrel_dir}";

	doins -r icons log4j.properties plugins

	java-pkg_dojar ${PN}.jar;
	for jar in lib/*.jar; do
		java-pkg_dojar "${jar}"
		java-pkg_regjar "${jar}"
	done

	for backend in ${IUSE}; do
		use "${backend}" && {
			local jb;
			if [ "${backend}" == "postgres" ]; then
				jb="postgresql";
			elif [ "${backend}" == "mssql" ]; then
				jb="mssqlserver";
			elif [ "${backend}" == "sybase" ]; then
				jb="jtds";
			elif [ "${backend}" == "firebird" ]; then
				jb="jaybird";
			elif [ "${backend}" == "oracle" ]; then
				jb="oracle-bin";
			else
				jb="${backend}";
			fi
			for jar in $(find /usr/share/jdbc-${jb}/lib/ -name '*.jar' 2>/dev/null); do
				java-pkg_regjar "${jar}"
			done;
		}
	done

	use postgres && (
		java-pkg_regjar plugins/postgres/lib/postgis-jdbc-1.3.3.jar
	)

	java-pkg_dolauncher "${PN}" --main net.sourceforge.squirrel_sql.client.Main --java_args "-splash:${squirrel_dir}/icons/splash.jpg" --pkg_args "--log-config-file ${squirrel_dir}/log4j.properties --squirrel-home ${squirrel_dir}" --pwd "${squirrel_dir}" 
}

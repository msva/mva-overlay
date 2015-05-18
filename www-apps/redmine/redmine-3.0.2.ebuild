# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"
USE_RUBY="jruby ruby20 ruby21 ruby22"

inherit eutils depend.apache user ruby-ng

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI="http://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="bazaar cvs darcs fastcgi git imagemagick mercurial mysql passenger postgres sqlite3 subversion ldap"

RDEPEND="|| ( $(ruby_implementation_depend ruby20)[ssl] $(ruby_implementation_depend ruby21)[ssl] $(ruby_implementation_depend ruby22)[ssl] )"

ruby_add_rdepend "
	dev-ruby/bundler
	virtual/rubygems
	passenger? ( || ( www-apache/passenger www-servers/nginx[nginx_modules_http_passenger] ) )
	fastcgi? (
		dev-ruby/fcgi
	)
"

RDEPEND="
	${RDEPEND}
	imagemagick? ( media-gfx/imagemagick )
	postgres? ( dev-db/postgresql )
	sqlite3? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	bazaar? ( dev-vcs/bzr )
	cvs? ( >=dev-vcs/cvs-1.12 )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( >=dev-vcs/subversion-1.3 )
"

REDMINE_DIR="${REDMINE_DIR:-/var/lib/${PN}}"

pkg_setup() {
	enewgroup "${HTTPD_GROUP:-redmine}"
	# home directory is required for SCM.
	enewuser "${HTTPD_USER-redmine}" -1 -1 "${REDMINE_DIR}" "${HTTPD_USER:-redmine}"
}

all_ruby_prepare() {
	rm -r log files/delete.me || die

	echo "CONFIG_PROTECT=\"${EPREFIX}${REDMINE_DIR}/config\"" > "${T}/50${PN}"
	echo "CONFIG_PROTECT_MASK=\"${EPREFIX}${REDMINE_DIR}/config/locales ${EPREFIX}${REDMINE_DIR}/config/settings.yml\"" >> "${T}/50${PN}"
	echo "RAILS_ENV=${RAILS_ENV:-production}" >> "${T}/50${PN}"
}

all_ruby_install() {
	local REDMINE_USER REDMINE_GROUP
	REDMINE_USER="${HTTPD_USER:-redmine}"
	REDMINE_GROUP="${HTTPD_GROUP:-redmine}"

	use ldap || (
		rm app/models/auth_source_ldap.rb
		epatch "${FILESDIR}/no_ldap.patch"
	)
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING} || die
	rm -r doc || die
	dodoc README.rdoc || die
	rm README.rdoc || die

	keepdir /var/log/${PN} || die
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log" || die

	insinto "${REDMINE_DIR}"
	doins -r . || die
	keepdir "${REDMINE_DIR}/files" || die
	keepdir "${REDMINE_DIR}/public/plugin_assets" || die

	fowners -R "${REDMINE_USER}:${REDMINE_GROUP}" \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die
	# for SCM
	fowners "${REDMINE_USER}:${REDMINE_GROUP}" "${REDMINE_DIR}" || die
	# bug #406605
	fperms -R go-rwx \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die

	if use passenger ; then
		has_apache
		if [[ $APACHE_VERSION -gt 0 ]]; then
			insinto "${APACHE_VHOSTS_CONFDIR}"
			doins "${FILESDIR}/10_redmine_vhost.conf" || die
		fi
	else
		newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
		newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
	fi
	doenvd "${T}/50${PN}" || die
}

pkg_postinst() {
	einfo
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following commands to initlize environment:"
		elog
		elog "# cd ${EPREFIX}${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml # (configure your database connection)"
		elog "# chown "${REDMINE_USER}:${REDMINE_GROUP}" config/database.yml"
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
	einfo
}

pkg_config() {
	if [ ! -e "${EPREFIX}${REDMINE_DIR}/config/database.yml" ] ; then
		eerror "Copy ${EPREFIX}${REDMINE_DIR}/config/database.yml.example to ${EPREFIX}${REDMINE_DIR}/config/database.yml and edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}
	local RUBY=${RUBY:-ruby}
	local without

	without="--without"
	use ldap || without="${without} ldap"
	use mysql || without="${without} mysql"
	use postgres || without="${without} postgresql"
	use imagemagick || without="${without} rmagick"
	use sqlite3 || without="${without} sqlite"
	without="${without} development test"

	cd "${EPREFIX}${REDMINE_DIR}"
	einfo "Installing and updating bundled gems, since it is ONLY way, supported by upstream and many plugins"
	RAILS_ENV="${RAILS_ENV}" bundle install --path ./vendor/bundle ${without}
	RAILS_ENV="${RAILS_ENV}" bundle update
	chown "${REDMINE_USER}":"${REDMINE_GROUP}" -R ./vendor/bundle
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		einfo
		einfo "Upgrade database."
		einfo

		einfo "Migrate database."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S bundle exec rake db:migrate || die
		einfo "Upgrade the plugin migrations."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S bundle exec rake redmine:plugins || die
		einfo "Clear the cache and the existing sessions."
		${RUBY} -S bundle exec rake tmp:cache:clear || die
		${RUBY} -S bundle exec rake tmp:sessions:clear || die
	else
		einfo
		einfo "Initialize database."
		einfo

		einfo "Generate a session store secret."
		${RUBY} -S bundle exec rake generate_secret_token || die
		einfo "Create the database structure."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S bundle exec rake db:migrate || die
		einfo "Insert default configuration data in database."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S bundle exec rake redmine:load_default_data || die
		if use sqlite3; then
			einfo
			einfo "Please do not forget to change the ownership of the sqlite files."
			einfo
			einfo "# cd \"${EPREFIX}${REDMINE_DIR}\""
			einfo "# chown "${REDMINE_USER}:${REDMINE_GROUP}" db/ db/*.sqlite3"
			einfo
		fi
	fi
}

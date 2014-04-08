# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby18 jruby ruby19 ruby20 ruby21"

inherit eutils confutils user git-r3 depend.apache

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/redmine/redmine.git"


KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"
IUSE="cvs darcs git imagemagick mercurial mysql passenger postgres sqlite3 subversion mongrel fastcgi"

DEPEND="
	>=dev-ruby/rails-2.3.4:2.3
	dev-ruby/activerecord:2.3[mysql?,postgres?,sqlite3?]
	imagemagick? ( dev-ruby/rmagick )
	fastcgi? ( dev-ruby/ruby-fcgi-ng )"

RDEPEND="${DEPEND}
	>=dev-ruby/ruby-net-ldap-0.0.4
	>=dev-ruby/coderay-0.7.6.227
	cvs? ( >=dev-vcs/cvs-1.12 )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( >=dev-vcs/subversion-1.3 )
	mongrel? (
			www-servers/mongrel_cluster
			www-servers/apache[apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_balancer]
		)
	passenger? (
			|| (
				www-apache/passenger
				www-servers/nginx[nginx_modules_http_passenger]
			)
		)
"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	confutils_require_any mysql postgres sqlite3
	if use mongrel ; then
		enewgroup mongrel
		enewuser  mongrel -1 -1 "${REDMINE_DIR}" mongrel
	fi
}

src_prepare() {
	rm -fr log files/delete.me
	rm -fr vendor/plugins/coderay-0.7.6.227
	rm -fr vendor/plugins/ruby-net-ldap-0.0.4
	echo "CONFIG_PROTECT=\"${REDMINE_DIR}/config\"" > "${T}/50${PN}"
}

src_install() {
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING}
	rm -fr doc

	keepdir /var/log/${PN}
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log"

	insinto "${REDMINE_DIR}"
	doins -r . || die
	keepdir "${REDMINE_DIR}/files"

	if use mongrel ; then
		has_apache
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf" || die
		dodir /etc/mongrel_cluster || die
		dodir "${REDMINE_DIR}/tmp/pids" || die
		dosym "${REDMINE_DIR}/config/mongrel_cluster.yml" /etc/mongrel_cluster/redmine.yml || die
		doinitd /usr/lib/ruby/gems/1.8/gems/mongrel_cluster-1.0.5/resources/mongrel_cluster || die
		fowners -R mongrel:mongrel \
			"${REDMINE_DIR}/config/environment.rb" \
			"${REDMINE_DIR}/files" \
			"${REDMINE_DIR}/tmp" \
			/var/log/${PN} || die
		# for SCM
		fowners mongrel:mongrel "${REDMINE_DIR}" || die
	fi
	doenvd "${T}/50${PN}" || die
}

pkg_postinst() {

	einfo
	elog "Execute the following command to initlize environment:"
	elog
	elog "# cd ${REDMINE_DIR}"
	elog "# cp config/database.yml.example config/database.yml"
	elog "# ${EDITOR:-/usr/bin/nano} config/database.yml"
	elog "# emerge --config =${PF}"
	elog
	elog "Execute the following command to upgrade environment:"
	elog
	elog "# emerge --config =${PF}"
	elog
	elog "Installation notes are at official site"
	elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	elog
	elog "For upgrade instructions take a look at:"
	elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	einfo
}

pkg_config() {
	if [ ! -e "${REDMINE_DIR}/config/database.yml" ] ; then
		eerror "Copy ${REDMINE_DIR}/config/database.yml.example to ${REDMINE_DIR}/config/database.yml and edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}

	pwd
	echo ${FILESDIR}

	cd "${REDMINE_DIR}"

	if [ -e "${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		einfo
		einfo "Upgrade database."
		einfo

		einfo "Migrate database."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Upgrade the plugin migrations."
		#RAILS_ENV="${RAILS_ENV}" rake db:migrate:upgrade_plugin_migrations || die
		RAILS_ENV="${RAILS_ENV}" rake db:migrate_plugins || die
		einfo "Clear the cache and the existing sessions."
		rake tmp:cache:clear || die
		rake tmp:sessions:clear || die
	else
		einfo
		einfo "Initialize database."
		einfo

		einfo "Generate a session store secret."
		rake config/initializers/session_store.rb || die
		einfo "Create the database structure."
		RAILS_ENV="${RAILS_ENV}" rake db:migrate || die
		einfo "Insert default configuration data in database."
		RAILS_ENV="${RAILS_ENV}" rake redmine:load_default_data || die
	fi
	if use mongrel ; then
		einfo "Configure mongrel rails."
		mongrel_rails cluster::configure -e production -p 8000 -N 3 -c $REDMINE_DIR --user mongrel --group mongrel
		einfo
		einfo "You need to edit your /etc/conf.d/apache2 file and"
	    einfo "add '-D PROXY' to APACHE2_OPTS."
		einfo
		einfo "Execute the following command to start Redmine:"
		einfo "# ${EDITOR:-/usr/bin/nano} /etc/apache2/vhosts.d/10_redmine_vhost.conf"
		einfo "# /etc/init.d/mongrel_cluster start"
		einfo "# /etc/init.d/apache2 start"
		einfo
	fi
}

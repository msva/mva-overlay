# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"
#ruby31"

inherit ruby-ng

DESCRIPTION="Flexible project management webapp written using Ruby on Rails framework"
HOMEPAGE="https://www.redmine.org/"

if [[ "${PV}" =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/redmine/redmine.git"
	inherit git-r3
	all_ruby_unpack() {
		EGIT_CHECKOUT_DIR=${S}
		git-r3_src_unpack
	}
else
	SRC_URI="https://www.redmine.org/releases/${P}.tar.gz"
	KEYWORDS="~amd64"
	# ~x86
	# ^ dev-ruby/rqrcode
	# also commonmark deps
fi
LICENSE="GPL-2"
SLOT="0"
IUSE="imagemagick ldap markdown commonmark +minimagick mysql pdf postgres sqlite abi_x86_x32"

# Order is like in Gemfile to ease maintenance:
ruby_add_rdepend "
	dev-ruby/bundler:=
	dev-ruby/rails:6.1
	>=dev-ruby/rouge-3.29.0
	>=dev-ruby/request_store-1.5.0:0
	>=dev-ruby/mini_mime-1.0.1
	dev-ruby/actionpack-xml_parser:2
	dev-ruby/roadie-rails:3
	dev-ruby/marcel
	>=dev-ruby/mail-2.7.1
	dev-ruby/csv:3
	>=dev-ruby/nokogiri-1.11.1
	>=dev-ruby/i18n-1.8.2:1
	>=dev-ruby/rbpdf-1.20.0
	dev-ruby/addressable
	>=dev-ruby/rubyzip-2.3.0:2
	dev-ruby/net-smtp
	dev-ruby/net-imap
	dev-ruby/net-pop
	>=dev-ruby/rotp-5.0.0
	dev-ruby/rqrcode
	minimagick? ( >=dev-ruby/mini_magick-4.11.0 )
	markdown? ( >=dev-ruby/redcarpet-3.5.1 )
	commonmark? (
		>=dev-ruby/html-pipeline-2.3.12
		>=dev-ruby/commonmarker-0.23.4
		>=dev-ruby/sanitize-6.0.0
	)
	mysql? ( >=dev-ruby/mysql2-0.5.0:0.5 )
	postgres? ( >=dev-ruby/pg-1.2.2:1 )
	sqlite? ( >=dev-ruby/sqlite3-1.4.0 )
	virtual/rubygems
"

RDEPEND="
	${RDEPEND}
	acct-user/redmine
	acct-group/redmine
	imagemagick? ( media-gfx/imagemagick )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	pdf? (
		app-text/ghostscript-gpl
		media-gfx/imagemagick
	)
	ruby_targets_ruby27? (
		dev-ruby/rexml[ruby_targets_ruby27]
		ldap? ( >=dev-ruby/ruby-net-ldap-0.17.0[ruby_targets_ruby27] )
	)
	!abi_x86_x32? ( commonmark? ( dev-ruby/deckar01-task_list[ruby_targets_ruby27=,ruby_targets_ruby30=] ) )
"

REQUIRED_USE="${REQUIRED_USE} ruby_targets_ruby30? ( !ldap ) abi_x86_x32? ( !commonmark )"

REDMINE_DIR="${REDMINE_DIR:-/var/lib/${PN}}"

RESTRICT="test"

all_ruby_prepare() {
	rm -fr log files/delete.me .github || die

	# bug #406605
	rm .{git,hg}ignore || die

	# newenvd not working here
	cat > "${T}/50${PN}" <<-EOF || die
		CONFIG_PROTECT="${EROOT}/${REDMINE_DIR}/config"
		CONFIG_PROTECT_MASK="${EROOT}/${REDMINE_DIR}/config/locales ${EROOT}/${REDMINE_DIR}/config/settings.yml"
		RAILS_ENV="${RAILS_ENV:-production}"
	EOF
	# Fixing versions in Gemfile
	sed -i -e "s/~>/>=/g" Gemfile || die

	# bug #724464
	sed -i -e "s/gem 'rails',.*/gem 'rails', '~>5.2.6'/" Gemfile || die

	sed -i -e "/group :development do/,/end$/d" Gemfile || die
	sed -i -e "/group :test do/,/end$/d" Gemfile || die

	if ! use imagemagick ; then
		sed -i -e "/group :minimagick do/,/end$/d" Gemfile || die
	fi
	if ! use ldap ; then
		# remove ldap stuff module if disabled to avoid #413779
		use ldap || rm app/models/auth_source_ldap.rb || die
		sed -i -e "/group :ldap do/,/end$/d" Gemfile || die
	fi
	if ! use markdown ; then
		sed -i -e "/group :markdown do/,/end$/d" Gemfile || die
	fi
}

all_ruby_install() {
	local REDMINE_USER REDMINE_GROUP
	REDMINE_USER="${HTTPD_USER:-redmine}"
	REDMINE_GROUP="${HTTPD_GROUP:-redmine}"

	local REDMINE_LOGDIR="/var/log/${PN}"

	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING} || die
	rm -r doc || die
	dodoc README.rdoc || die
	rm README.rdoc || die

	keepdir "${REDMINE_LOGDIR}" || die
	dosym "${REDMINE_LOGDIR}" "${REDMINE_DIR}/log" || die

	insinto "${REDMINE_DIR}"
	doins -r . || die

	keepdir "${REDMINE_DIR}"/app/views/previews
	keepdir "${REDMINE_DIR}"/test/{fixtures/{files/2016/12,mailer},mocks/{development,test},unit/lib/redmine/syntax_highlighting}
	keepdir "${REDMINE_DIR}"/tmp/{cache,imports,sessions,sockets}
	keepdir "${REDMINE_DIR}"/vendor

	keepdir "${REDMINE_DIR}/files" || die
	keepdir "${REDMINE_DIR}/public/plugin_assets" || die

	fowners -R "${REDMINE_USER}:${REDMINE_GROUP}" \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		"${REDMINE_LOGDIR}" || die
	# for SCM
	fowners "${REDMINE_USER}:${REDMINE_GROUP}" "${REDMINE_DIR}" || die
	# bug #406605
	fperms -R go-rwx \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/tmp" \
		"${REDMINE_LOGDIR}" || die

	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
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
	use sqlite || without="${without} sqlite"
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
		if use sqlite; then
			einfo
			einfo "Please do not forget to change the ownership of the sqlite files."
			einfo
			einfo "# cd \"${EPREFIX}${REDMINE_DIR}\""
			einfo "# chown "${REDMINE_USER}:${REDMINE_GROUP}" db/ db/*.sqlite3"
			einfo
		fi
	fi
}

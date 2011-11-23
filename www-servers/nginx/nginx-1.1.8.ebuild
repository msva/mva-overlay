# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following 3 requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly
# - TODO: test the google-perftools module (included in vanilla tarball)

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# http_passenger (http://www.modrails.com/, MIT license)
# TODO: currently builds some stuff in src_configure
PASSENGER_PV="3.0.9"
USE_RUBY="ruby18 ree18 jruby"
RUBY_OPTIONAL="yes"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_AUTHOR="masterzen"
HTTP_UPLOAD_PROGRESS_MODULE_NAME="ngx_upload_progress"
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.8.3"
HTTP_UPLOAD_PROGRESS_MODULE_P="${HTTP_UPLOAD_PROGRESS_MODULE_NAME}-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"
HTTP_UPLOAD_PROGRESS_MODULE_SHA1="c7c663f"

# http_headers_more (http://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.16rc3"
HTTP_HEADERS_MORE_MODULE_P="ngx-http-headers-more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_SHA1="be6a17e"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.692"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="1.4"
HTTP_CACHE_PURGE_MODULE_P="ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# HTTP Upload module from Valery Kholodkov
# (http://www.grid.net.ru/nginx/upload.en.html, BSD license)
HTTP_UPLOAD_MODULE_PV="2.2.0"
HTTP_UPLOAD_MODULE_P="nginx_upload_module-${HTTP_UPLOAD_MODULE_PV}"

# ey-balancer/maxconn module (https://github.com/ry/nginx-ey-balancer, as-is)
HTTP_EY_BALANCER_MODULE_PV="0.0.6"
HTTP_EY_BALANCER_MODULE_P="nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_PV}"
HTTP_EY_BALANCER_MODULE_SHA1="d373670"

# NginX DevKit module (https://github.com/simpl/ngx_devel_kit, BSD)
HTTP_NDK_MODULE_PV="0.2.17rc2"
HTTP_NDK_MODULE_P="ngx_devel_kit-${HTTP_NDK_MODULE_PV}"
HTTP_NDK_MODULE_SHA1="bc97eea"

# NginX DevKit module (https://github.com/simpl/ngx_devel_kit, BSD)
HTTP_SET_HASH_MODULE_AUTHOR="simpl"
HTTP_SET_HASH_MODULE_NAME="ngx_http_set_hash"
HTTP_SET_HASH_MODULE_PV="0.2.1"
HTTP_SET_HASH_MODULE_SHA1="cfdd587"
HTTP_SET_HASH_MODULE_P="${HTTP_SET_HASH_MODULE_NAME}-${HTTP_NDK_MODULE_PV}"
HTTP_SET_HASH_MODULE_PB="${HTTP_SET_HASH_MODULE_AUTHOR}-${HTTP_SET_HASH_MODULE_NAME}-${HTTP_NDK_MODULE_SHA1}"

# NginX Lua module (https://github.com/chaoslawful/lua-nginx-module, BSD)
HTTP_LUA_MODULE_PV="0.3.1rc19"
HTTP_LUA_MODULE_P="lua-nginx-module-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_SHA1="b25d06b"

# NginX Lua module (https://github.com/chaoslawful/lua-nginx-module, BSD)
HTTP_DRIZZLE_MODULE_PV="0.1.2rc2"
HTTP_DRIZZLE_MODULE_P="drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_PV}"
HTTP_DRIZZLE_MODULE_SHA1="44f8593"

# NginX for-input module (https://github.com/calio/form-input-nginx-module, BSD)
HTTP_FORM_INPUT_MODULE_PV="0.07rc5"
HTTP_FORM_INPUT_MODULE_P="form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_PV}"
HTTP_FORM_INPUT_MODULE_SHA1="d41681d"

# NginX echo module (https://github.com/agentzh/echo-nginx-module, BSD)
HTTP_ECHO_MODULE_PV="0.37rc7"
HTTP_ECHO_MODULE_P="echo-nginx-module-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_SHA1="b7ea185"

# NginX Featured mecached module (https://github.com/agentzh/memc-nginx-module, BSD)
HTTP_MEMC_MODULE_PV="0.13rc1"
HTTP_MEMC_MODULE_P="memc-nginx-module-${HTTP_MEMC_MODULE_PV}"
HTTP_MEMC_MODULE_SHA1="5b0504b"

# NginX RDS-JSON module (https://github.com/agentzh/rds-json-nginx-module, BSD)
HTTP_RDS_JSON_MODULE_PV="0.12rc6"
HTTP_RDS_JSON_MODULE_P="rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_PV}"
HTTP_RDS_JSON_MODULE_SHA1="1152ade"

# NginX SRCache module (https://github.com/agentzh/srcache-nginx-module, BSD)
HTTP_SRCACHE_MODULE_PV="0.13rc2"
HTTP_SRCACHE_MODULE_P="srcache-nginx-module-${HTTP_SRCACHE_MODULE_PV}"
HTTP_SRCACHE_MODULE_SHA1="86e7a18"

# NginX Set-Misc module (https://github.com/agentzh/set-misc-nginx-module, BSD)
HTTP_SET_MISC_MODULE_PV="0.22rc3"
HTTP_SET_MISC_MODULE_P="set-misc-nginx-module-${HTTP_SET_MISC_MODULE_PV}"
HTTP_SET_MISC_MODULE_SHA1="7adef5a"

# NginX XSS module (https://github.com/agentzh/xss-nginx-module, BSD)
HTTP_XSS_MODULE_PV="0.03rc3"
HTTP_XSS_MODULE_P="xss-nginx-module-${HTTP_XSS_MODULE_PV}"
HTTP_XSS_MODULE_SHA1="8618dd3"

# NginX Array-Var module (https://github.com/agentzh/array-var-nginx-module, BSD)
HTTP_ARRAY_VAR_MODULE_PV="0.03rc1"
HTTP_ARRAY_VAR_MODULE_P="array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_PV}"
HTTP_ARRAY_VAR_MODULE_SHA1="fed751a"

# NginX Encrypt Session module (https://github.com/agentzh/encrypted-session-nginx-module, BSD)
HTTP_ENCS_MODULE_PV="0.01"
HTTP_ENCS_MODULE_P="encrypted-session-nginx-module-${HTTP_ENCS_MODULE_PV}"
HTTP_ENCS_MODULE_SHA1="26da7fc"

# NginX Encrypt Session module (https://github.com/agentzh/redis2-nginx-module, BSD)
HTTP_REDIS2_MODULE_PV="0.08rc1"
HTTP_REDIS2_MODULE_P="redis2-nginx-module-${HTTP_REDIS2_MODULE_PV}"
HTTP_REDIS2_MODULE_SHA1="23cf589"

#NginX RDS-Parser   (git://github.com/agentzh/lua-rds-parser.git, BSD)
#NginX Redis Parser (git://github.com/agentzh/lua-redis-parser.git, BSD)

# NginX RDS-CSV module (https://github.com/agentzh/rds-csv-nginx-module, BSD)
HTTP_RDS_CSV_MODULE_PV="0.04"
HTTP_RDS_CSV_MODULE_P="rds-csv-nginx-module-${HTTP_RDS_CSV_MODULE_PV}"
HTTP_RDS_CSV_MODULE_SHA1="4cd999b"

# NginX Iconv module (https://github.com/calio/iconv-nginx-module, BSD)
HTTP_ICONV_MODULE_PV="0.10rc5"
HTTP_ICONV_MODULE_P="iconv-nginx-module-${HTTP_ICONV_MODULE_PV}"
HTTP_ICONV_MODULE_SHA1="4e71946"

## NginX Set-CConv module (https://github.com/liseen/set-cconv-nginx-module, BSD)
#HTTP_SET_CCONV_MODULE_PV=""
#HTTP_SET_CCONV_MODULE_P="set-cconv-nginx-module-${HTTP_SET_CCONV_MODULE_PV}"
#HTTP_SET_CCONV_MODULE_SHA1=""

# NginX Featured mecached module (http://labs.frickle.com/nginx_ngx_postgres, BSD-2)
HTTP_POSTGRES_MODULE_PV="0.9rc2"
HTTP_POSTGRES_MODULE_P="ngx_postgres-${HTTP_POSTGRES_MODULE_PV}"
HTTP_POSTGRES_MODULE_SHA1="5cb9d09"

# NginX coolkit module (http://labs.frickle.com/nginx_ngx_coolkit/, BSD-2)
HTTP_COOLKIT_MODULE_PV="1.0"
HTTP_COOLKIT_MODULE_P="ngx_coolkit-${HTTP_COOLKIT_MODULE_PV}"

# NginX Supervisord module (http://labs.frickle.com/nginx_ngx_supervisord/, BSD-2)
HTTP_SUPERVISORD_MODULE_PV="1.4"
HTTP_SUPERVISORD_MODULE_P="ngx_supervisord-${HTTP_SUPERVISORD_MODULE_PV}"

# NginX Auth Request module (BSD)
HTTP_AUTH_REQUEST_MODULE_PV="0.2"
HTTP_AUTH_REQUEST_MODULE_P="ngx_http_auth_request_module-${HTTP_AUTH_REQUEST_MODULE_PV}"

# NginX Auth Request module (BSD)
HTTP_UPSTREAM_KEEPALIVE_MODULE_PV="0.7"
HTTP_UPSTREAM_KEEPALIVE_MODULE_P="ngx_http_upstream_keepalive-${HTTP_UPSTREAM_KEEPALIVE_MODULE_PV}"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.6"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

CHUNKIN_MODULE_PV="0.22rc2"
CHUNKIN_MODULE_P="chunkin-nginx-module-${CHUNKIN_MODULE_PV}"
CHUNKIN_MODULE_SHA1="b46dd27"

PAM_MODULE_PV="1.2"
PAM_MODULE_P="ngx_http_auth_pam_module-${PAM_MODULE_PV}"

REDIS_MODULE_PV="0.3.5"
REDIS_MODULE_P="ngx_http_redis-${REDIS_MODULE_PV}"

RRD_MODULE_PV="0.2.0"
RRD_MODULE_P="mod_rrd_graph-${RRD_MODULE_PV}"
RRD_MODULE_D="Mod_rrd_graph-${RRD_MODULE_PV}"

inherit eutils ssl-cert toolchain-funcs perl-module ruby-ng flag-o-matic

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://sysoev.ru/nginx/
	http://www.modrails.com/
	http://pushmodule.slact.net/
	http://labs.frickle.com/nginx_ngx_cache_purge/"
SRC_URI="http://nginx.org/download/${P}.tar.gz
	nginx_modules_http_headers_more? ( https://github.com/agentzh/headers-more-nginx-module/tarball/v${HTTP_HEADERS_MORE_MODULE_PV} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? ( mirror://rubyforge/passenger/passenger-${PASSENGER_PV}.tar.gz )
	nginx_modules_http_push? ( http://pushmodule.slact.net/downloads/${HTTP_PUSH_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( http://labs.frickle.com/files/${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_upload? ( http://www.grid.net.ru/nginx/download/${HTTP_UPLOAD_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( https://github.com/ry/nginx-ey-balancer/tarball/v${HTTP_EY_BALANCER_MODULE_PV} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_ndk? ( https://github.com/simpl/ngx_devel_kit/tarball/v${HTTP_NDK_MODULE_PV} -> ${HTTP_NDK_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( https://github.com/chaoslawful/lua-nginx-module/tarball/v${HTTP_LUA_MODULE_PV} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_drizzle? ( https://github.com/chaoslawful/drizzle-nginx-module/tarball/v${HTTP_DRIZZLE_MODULE_PV} -> ${HTTP_DRIZZLE_MODULE_P}.tar.gz )
	nginx_modules_http_form_input? ( https://github.com/calio/form-input-nginx-module/tarball/v${HTTP_FORM_INPUT_MODULE_PV} -> ${HTTP_FORM_INPUT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( https://github.com/agentzh/echo-nginx-module/tarball/v${HTTP_ECHO_MODULE_PV} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_rds_json? ( https://github.com/agentzh/rds-json-nginx-module/tarball/v${HTTP_RDS_JSON_MODULE_PV} -> ${HTTP_RDS_JSON_MODULE_P}.tar.gz )
	nginx_modules_http_srcache? ( https://github.com/agentzh/srcache-nginx-module/tarball/v${HTTP_SRCACHE_MODULE_PV} -> ${HTTP_SRCACHE_MODULE_P}.tar.gz )
	nginx_modules_http_set_misc? ( https://github.com/agentzh/set-misc-nginx-module/tarball/v${HTTP_SET_MISC_MODULE_PV} -> ${HTTP_SET_MISC_MODULE_P}.tar.gz )
	nginx_modules_http_xss? ( https://github.com/agentzh/xss-nginx-module/tarball/v${HTTP_XSS_MODULE_PV} -> ${HTTP_XSS_MODULE_P}.tar.gz )
	nginx_modules_http_array_var? ( https://github.com/agentzh/array-var-nginx-module/tarball/v${HTTP_ARRAY_VAR_MODULE_PV} -> ${HTTP_ARRAY_VAR_MODULE_P}.tar.gz )
	nginx_modules_http_iconv? ( https://github.com/calio/iconv-nginx-module/tarball/v${HTTP_ICONV_MODULE_PV} -> ${HTTP_ICONV_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( https://github.com/agentzh/memc-nginx-module/tarball/v${HTTP_MEMC_MODULE_PV} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_encrypted_session? ( https://github.com/agentzh/encrypted-session-nginx-module/tarball/v${HTTP_ENCS_MODULE_PV} -> ${HTTP_ENCS_MODULE_P}.tar.gz )
	nginx_modules_http_redis2? ( https://github.com/agentzh/redis2-nginx-module/tarball/v${HTTP_REDIS2_MODULE_PV} -> ${HTTP_REDIS2_MODULE_P}.tar.gz )
	nginx_modules_http_redis? ( http://people.freebsd.org/~osa/${REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_postgres? ( https://github.com/FRiCKLE/ngx_postgres/tarball/${HTTP_POSTGRES_MODULE_PV} -> ${HTTP_POSTGRES_MODULE_P}.tar.gz )
	nginx_modules_http_coolkit? ( http://labs.frickle.com/files/${HTTP_COOLKIT_MODULE_P}.tar.gz )
	nginx_modules_http_upload_progress? ( https://github.com/masterzen/nginx-upload-progress-module/tarball/v${HTTP_UPLOAD_PROGRESS_MODULE_PV} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_supervisord? ( http://labs.frickle.com/files/${HTTP_SUPERVISORD_MODULE_P}.tar.gz )
	nginx_modules_http_auth_request? ( http://mdounin.ru/files/${HTTP_AUTH_REQUEST_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_keepalive? ( http://mdounin.ru/files/${HTTP_UPSTREAM_KEEPALIVE_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( http://labs.frickle.com/files/${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	pam? ( http://web.iti.upv.es/~sto/nginx/${PAM_MODULE_P}.tar.gz )
	rrd? ( http://wiki.nginx.org/images/9/9d/${RRD_MODULE_D}.tar.gz )
	chunk? ( https://github.com/agentzh/chunkin-nginx-module/tarball/v${CHUNKIN_MODULE_PV} -> ${CHUNKIN_MODULE_P}.tar.gz )"
#	nginx_modules_http_set_cconv? ( http://github.com/liseen/set-cconv-nginx-module/tarball/v${HTTP_SET_CCONV_MODULE_PV} -> ${HTTP_SET_CCON_MODULE_P}.tar.gz )

LICENSE="BSD BSD-2 GPL-2 MIT
	pam? ( as-is )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip limit_req limit_zone map memcached proxy referer rewrite scgi ssi
split_clients upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition dav degradation flv geoip gzip_static image_filter
mp4 perl random_index realip secure_link stub_status sub xslt"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="http_cache_purge http_headers_more http_passenger http_push
http_upload http_ey_balancer http_slowfs_cache http_ndk http_lua http_form_input
http_echo http_memc http_drizzle http_rds_json http_postgres http_coolkit
http_auth_request http_set_misc http_srcache http_supervisord http_array_var
http_xss http_iconv http_upload_progress http_encrypted_session http_redis2 http_redis http_upstream_keepalive"
# http_set_cconv"

REQUIRED_USE="	nginx_modules_http_lua? ( nginx_modules_http_ndk )
		nginx_modules_http_rds_json? ( || ( nginx_modules_http_drizzle nginx_modules_http_postgres ) )
		nginx_modules_http_form_input? ( nginx_modules_http_ndk )
		nginx_modules_http_set_misc? ( nginx_modules_http_ndk )
		nginx_modules_http_iconv? ( nginx_modules_http_ndk )
		nginx_modules_http_encrypted_session? ( nginx_modules_http_ndk )
		nginx_modules_http_array_var? ( nginx_modules_http_ndk )"
#		nginx_modules_http_set_cconv? ( nginx_modules_http_ndk )

IUSE="aio chunk debug +http +http-cache ipv6 libatomic pam +pcre perftools rrd ssl vim-syntax +luajit"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

CDEPEND="
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	http-cache? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_geo? ( dev-libs/geoip )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_drizzle? ( dev-db/drizzle )
	nginx_modules_http_lua? ( luajit? ( dev-lang/luajit:2 ) !luajit? ( >=dev-lang/lua-5.1 ) )
	nginx_modules_http_passenger? (
		$(ruby_implementation_depend ruby18)
		>=dev-ruby/rubygems-0.9.0
		>=dev-ruby/rake-0.8.1
		>=dev-ruby/fastthread-1.0.1
		>=dev-ruby/rack-1.0.0
		!!www-apache/passenger
	)
	perftools? ( dev-util/google-perftools )
	rrd? ( >=net-analyzer/rrdtool-1.3.8 )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}

	if use libatomic; then
		ewarn ""
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn ""
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use nginx_modules_http_passenger; then
		ruby-ng_pkg_setup
		if [[ ${PV//.} -gt 113 ]]; then
			ewarn ""
			ewarn "If you planning to use Passenger with Rails3 applications"
			ewarn "you should downgrade NginX to 1.1.3."
			ewarn "Due to some API changes Rails3 apps don't working under NginX >=1.1.4"
		fi
		use debug && append-flags -DPASSENGER_DEBUG
	fi

	if use !http; then
		ewarn ""
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
	use pam && unpack "${PAM_MODULE_P}.tar.gz"
	use rrd && unpack "${RRD_MODULE_D}.tar.gz"
	use chunk && unpack "${CHUNKIN_MODULE_P}.tar.gz"
}

src_prepare() {
	sed -i -e 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make

	sed -i -e "s|\(NGX_MAX_ERROR_STR\)   2048|\1 4096|" "${S}"/src/core/ngx_log.h

	if use nginx_modules_http_ey_balancer; then
		epatch "${FILESDIR}"/nginx-1.x-ey-balancer.patch
	fi

	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-"${PASSENGER_PV}";

		epatch "${FILESDIR}"/passenger-"${PASSENGER_PV}"-gentoo.patch
		epatch "${FILESDIR}"/passenger-"${PASSENGER_PV}"-ldflags.patch
		epatch "${FILESDIR}"/passenger-"${PASSENGER_PV}"-contenthandler.patch

		sed -i -e "s:/usr/share/doc/phusion-passenger:/usr/share/doc/${P}:" \
		-e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/passenger/agents:" lib/phusion_passenger.rb || die
		sed -i -e "s:/usr/lib/phusion-passenger/agents:/usr/libexec/passenger/agents:" ext/common/ResourceLocator.h || die
		sed -i -e '/passenger-install-apache2-module/d' -e "/passenger-install-nginx-module/d" lib/phusion_passenger/packaging.rb || die
		rm -f bin/passenger-install-apache2-module bin/passenger-install-nginx-module || die "Unable to remove unneeded install script."
	fi
}

src_configure() {
	local myconf= http_enabled= mail_enabled=

	use aio && myconf="${myconf} --with-file-aio --with-aio_module"
	use debug && myconf="${myconf} --with-debug"
	use ipv6 && myconf="${myconf} --with-ipv6"
	use libatomic && myconf="${myconf} --with-libatomic"
	use pcre && myconf="${myconf} --with-pcre"

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf="${myconf} --without-http_${mod}_module"
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf="${myconf} --with-http_${mod}_module"
		fi
	done

	# third-party modules
	# WARNING!!! Modules (that checked with "(**)" comment) adding order IS IMPORTANT!
# (**) http_ndk
	if use nginx_modules_http_ndk; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/simpl-ngx_devel_kit-${HTTP_NDK_MODULE_SHA1}"
	fi

# (**) http_set_misc
	if use nginx_modules_http_set_misc; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-set-misc-nginx-module-${HTTP_SET_MISC_MODULE_SHA1}"
	fi

# (**)http_ auth_request
	if use nginx_modules_http_auth_request; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_AUTH_REQUEST_MODULE_P}"
	fi

# (**) http_echo
	if use nginx_modules_http_echo; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-echo-nginx-module-${HTTP_ECHO_MODULE_SHA1}"
	fi

# (**) http_memc
	if use nginx_modules_http_memc; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-memc-nginx-module-${HTTP_MEMC_MODULE_SHA1}"
	fi
# (**) http_lua
	if use nginx_modules_http_lua; then
		http_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$(pkg-config --variable libdir luajit)
			export LUAJIT_INC=$(pkg-config --variable includedir luajit)
		else
			export LUA_LIB=$(pkg-config --variable libdir lua)
			export LUA_INC=$(pkg-config --variable includedir lua)			
		fi
		myconf="${myconf} --add-module=${WORKDIR}/chaoslawful-lua-nginx-module-${HTTP_LUA_MODULE_SHA1}"
	fi

# (**) http_headers_more
	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_SHA1}"
	fi

# (**) http_srcache
	if use nginx_modules_http_srcache; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-srcache-nginx-module-${HTTP_SRCACHE_MODULE_SHA1}"
	fi
	

# (**) http_drizzle
	if use nginx_modules_http_drizzle; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1}"
	fi

# (**) http_rds_json
	if use nginx_modules_http_rds_json; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1}"
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/FRiCKLE-ngx_postgres-${HTTP_POSTGRES_MODULE_SHA1}"
	fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_COOLKIT_MODULE_P}"
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/passenger-${PASSENGER_PV}/ext/nginx"
	fi

# http_push
	if use nginx_modules_http_push; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_P}"
	fi

# http_supervisord
	if use nginx_modules_http_supervisord; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_SUPERVISORD_MODULE_P}"
	fi

# http_xss
	if use nginx_modules_http_xss; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-xss-nginx-module-${HTTP_XSS_MODULE_SHA1}"
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1}"
	fi

# http_encrypted_session
	if use nginx_modules_http_encrypted_session; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-encrypted-session-nginx-module-${HTTP_ENCS_MODULE_SHA1}"
	fi

# http_redis2
	if use nginx_modules_http_redis2; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-redis2-nginx-module-${HTTP_REDIS2_MODULE_SHA1}"
	fi

# http_redis
	if use nginx_modules_http_redis; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_REDIS_MODULE_P}"
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1}"
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1}"
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"
	fi

# http_set-cconv
#	if use nginx_modules_http_set_cconv; then
#		http_enabled=1
#		myconf="${myconf} --add-module=${WORKDIR}/liseen-set-cconv-nginx-module-${HTTP_SET_CCONV_MODULE_SHA1}"
#	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"
	fi

# http_upload
	if use nginx_modules_http_upload; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_UPLOAD_MODULE_P}"
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/ry-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"
	fi
# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_SLOWFS_CACHE_MODULE_P}"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf="${myconf} --without-http-cache"
		use ssl && myconf="${myconf} --with-http_ssl_module"
	else
		myconf="${myconf} --without-http --without-http-cache"
	fi

	use perftools && myconf="${myconf} --with-google_perftools_module"
	use rrd && myconf="${myconf} --add-module=${WORKDIR}/${RRD_MODULE_P}"
	use chunk && myconf="${myconf} --add-module=${WORKDIR}/agentzh-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1}"
	use pam && myconf="${myconf} --add-module=${WORKDIR}/${PAM_MODULE_P}"

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf="${myconf} --without-mail_${mod}_module"
		fi
	done

	if [ $mail_enabled ]; then
		myconf="${myconf} --with-mail"
		use ssl && myconf="${myconf} --with-mail_ssl_module"
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf="${myconf} --add-module=${mod}"
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	./configure \
		--prefix=/usr \
		--sbin-path=/usr/sbin/nginx \
		--conf-path=/etc/"${PN}"/"${PN}".conf \
		--error-log-path=/var/log/"${PN}"/error_log \
		--pid-path=/var/run/"${PN}".pid \
		--lock-path=/var/lock/nginx.lock \
		--user="${PN}" --group="${PN}" \
		--with-cc-opt="-I${ROOT}usr/include" \
		--with-ld-opt="-L${ROOT}usr/lib" \
		--http-log-path=/var/log/"${PN}"/access_log \
		--http-client-body-temp-path=/var/tmp/"${PN}"/client \
		--http-proxy-temp-path=/var/tmp/"${PN}"/proxy \
		--http-fastcgi-temp-path=/var/tmp/"${PN}"/fastcgi \
		--http-scgi-temp-path=/var/tmp/"${PN}"/scgi \
		--http-uwsgi-temp-path=/var/tmp/"${PN}"/uwsgi \
		${myconf} || die "configure failed"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	keepdir /var/log/"${PN}" /var/tmp/"${PN}"/{client,proxy,fastcgi,scgi,uwsgi}

	dosbin objs/nginx
	newinitd "${FILESDIR}"/nginx.init-r2 nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf
	rm conf/win-utf conf/koi-win conf/koi-utf

	dodir /etc/"${PN}"
	insinto /etc/"${PN}"
	doins conf/*

	doman man/nginx.8
	dodoc CHANGES* README

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx

# http_perl
	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		fixlocalpod
	fi

# http_push
	if use nginx_modules_http_push; then
		docinto "${HTTP_PUSH_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_PUSH_MODULE_P}"/{changelog.txt,protocol.txt,README}
	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		docinto "${HTTP_CACHE_PURGE_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_CACHE_PURGE_MODULE_P}"/{CHANGES,README.md}
	fi

# http_upload
	if use nginx_modules_http_upload; then
		docinto "${HTTP_UPLOAD_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_UPLOAD_MODULE_P}"/{Changelog,README}
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		docinto "${HTTP_UPLOAD_PROGRESS_MODULE_P}"
		dodoc "${WORKDIR}"/"masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"/README
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		docinto "${HTTP_EY_BALANCER_MODULE_P}"
		dodoc "${WORKDIR}"/"ry-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"/README
	fi

# http_ndk
	if use nginx_modules_http_ndk; then
		docinto "${HTTP_NDK_MODULE_P}"
		dodoc "${WORKDIR}"/"simpl-ngx_devel_kit-${HTTP_NDK_MODULE_SHA1}"/README
	fi

# http_lua
	if use nginx_modules_http_lua; then
		docinto "${HTTP_LUA_MODULE_P}"
		dodoc "${WORKDIR}"/"chaoslawful-lua-nginx-module-${HTTP_LUA_MODULE_SHA1}"/{Changes,README}
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		docinto "${HTTP_FORM_INPUT_MODULE_P}"
		dodoc "${WORKDIR}"/"calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1}"/README
	fi

# http_echo
	if use nginx_modules_http_echo; then
		docinto "${HTTP_ECHO_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-echo-nginx-module-${HTTP_ECHO_MODULE_SHA1}"/README
	fi

# http_srcache
	if use nginx_modules_http_srcache; then
		docinto "${HTTP_SRCACHE_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-srcache-nginx-module-${HTTP_SRCACHE_MODULE_SHA1}"/README
	fi

# http_memc
	if use nginx_modules_http_memc; then
		docinto "${HTTP_MEMC_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-memc-nginx-module-${HTTP_MEMC_MODULE_SHA1}"/README
	fi

# http_drizzle
	if use nginx_modules_http_drizzle; then
		docinto "${HTTP_DRIZZLE_MODULE_P}"
		dodoc "${WORKDIR}"/"chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1}"/README
	fi

# http_rds_json
	if use nginx_modules_http_rds_json; then
		docinto "${HTTP_RDS_JSON_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1}"/README
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		docinto "${HTTP_POSTGRES_MODULE_P}"
		dodoc "${WORKDIR}"/"FRiCKLE-ngx_postgres-${HTTP_POSTGRES_MODULE_SHA1}"/README.md
	fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		docinto "${HTTP_COOLKIT_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_COOLKIT_MODULE_P}"/README
	fi

# http_set_misc
	if use nginx_modules_http_set_misc; then
		docinto "${HTTP_SET_MISC_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-set-misc-nginx-module-${HTTP_SET_MISC_MODULE_SHA1}"/README
	fi

# http_xss
 	if use nginx_modules_http_xss; then
		docinto "${HTTP_XSS_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-xss-nginx-module-${HTTP_XSS_MODULE_SHA1}"/README
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		docinto "${HTTP_ARRAY_VAR_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1}"/README
	fi

# http_encrypted_session
	if use nginx_modules_http_encrypted_session; then
		docinto "${HTTP_ENCS_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-encrypted-session-nginx-module-${HTTP_ENCS_MODULE_SHA1}"/README
	fi

# http_redis2
	if use nginx_modules_http_redis2; then
		docinto "${HTTP_REDIS2_MODULE_P}"
		dodoc "${WORKDIR}"/"agentzh-redis2-nginx-module-${HTTP_REDIS2_MODULE_SHA1}"/README
	fi

# http_redis
	if use nginx_modules_http_redis; then
		docinto "${HTTP_REDIS_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_REDIS_MODULE_P}"/README
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		docinto "${HTTP_ICONV_MODULE_P}"
		dodoc "${WORKDIR}"/"calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1}"/README
	fi

# http_set_cconv
#	if use nginx_modules_http_set_cconv; then
#		docinto "${HTTP_SET_CCONV_MODULE_P}"
#		dodoc "${WORKDIR}"/"${HTTP_SET_CCONV_MODULE_P}"/README
#	fi

# http_supervisord
	if use nginx_modules_http_supervisord; then
		docinto "${HTTP_SUPERVISORD_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_SUPERVISORD_MODULE_P}"/README
	fi

# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		docinto "${HTTP_SLOWFS_CACHE_MODULE_P}"
		dodoc "${WORKDIR}"/"${HTTP_SLOWFS_CACHE_MODULE_P}"/{CHANGES,README}
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-"${PASSENGER_PV}"
		rake fakeroot
	fi

	use chunk && newdoc "${WORKDIR}/agentzh-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1}"/README README.chunkin
	use pam   && newdoc "${WORKDIR}/${PAM_MODULE_P}"/README README.pam
	use rrd   && newdoc "${WORKDIR}/${RRD_MODULE_P}"/README README.rrd
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${ROOT}"/etc/ssl/"${PN}"/"${PN}".key ]; then
			install_cert /etc/ssl/"${PN}"/"${PN}"
			chown "${PN}":"${PN}" "${ROOT}"/etc/ssl/"${PN}"/"${PN}".{crt,csr,key,pem}
		fi
	fi
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following 3 requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly
# - TODO: test the google-perftools module (included in vanilla tarball)
#		patch NginX to support module_path instead of `$prefix/modules` as module search path at runtime (?)
#		install nginx sources to /usr/src/
#		split 3party modules supporting being dynamic to www-nginx/

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

SSL_DEPS_SKIP=1

inherit eutils ssl-cert toolchain-funcs perl-module flag-o-matic user systemd pax-utils multilib patches

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="
	http://sysoev.ru/nginx/
	"
SRC_URI="
	http://nginx.org/download/${P}.tar.gz -> ${P}.tar.gz
	nginx_modules_stream_dtls? ( http://nginx.org/patches/dtls/nginx-1.13.0-dtls-experimental.diff )
"
LICENSE="
	BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
"
SLOT="mainline"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

NGINX_MODULES_STD="
	http_mirror
	http_access
	http_auth_basic
	http_autoindex
	http_browser
	http_charset
	http_empty_gif
	http_fastcgi
	http_geo
	http_gzip
	http_limit_conn
	http_limit_req
	http_map
	http_memcached
	http_proxy
	http_referer
	http_rewrite
	http_scgi
	http_split_clients
	http_ssi
	http_upstream_hash
	http_upstream_ip_hash
	http_upstream_keepalive
	http_upstream_least_conn
	http_upstream_zone
	http_userid
	http_uwsgi
	stream_access
	stream_geo
	stream_limit_conn
	stream_map
	stream_return
	stream_split_clients
	stream_upstream_hash
	stream_upstream_least_conn
	stream_upstream_zone
	mail_imap
	mail_pop3
	mail_smtp
"

NGINX_MODULES_OPT="
	http_addition
	http_auth_request
	http_dav
	http_degradation
	http_flv
	http_geoip
	http_gunzip
	http_gzip_static
	http_image_filter
	http_mp4
	http_perl
	http_random_index
	http_realip
	http_secure_link
	http_slice
	http_stub_status
	http_sub
	http_xslt
	http_v2
	stream_geoip
	stream_realip
	stream_ssl_preread
"

NGINX_MODULES_3P="
	stream_dtls
"

NGINX_MODULES_DYN="
	http_geoip
	http_image_filter
	http_xslt
	http_perl
	stream_geoip
	stream_dtls
"

REQUIRED_USE="
	luajit? (
		|| (
			nginx_modules_http_lua
			nginx_modules_stream_lua
		)
	)
	nginx_modules_http_v2? ( ssl )
	nginx_modules_stream_lua? ( ssl )
	nginx_modules_http_lua? ( nginx_modules_http_ndk nginx_modules_http_rewrite )
	nginx_modules_http_lua_upstream? ( nginx_modules_http_lua )
	nginx_modules_http_form_input? ( nginx_modules_http_ndk )
	nginx_modules_http_set_misc? ( nginx_modules_http_ndk )
	nginx_modules_http_iconv? ( nginx_modules_http_ndk )
	nginx_modules_http_encrypted_session? ( nginx_modules_http_ndk ssl )
	nginx_modules_http_fastcgi? ( nginx_modules_http_realip )
	nginx_modules_http_naxsi? ( pcre )
	nginx_modules_http_postgres? ( nginx_modules_http_rewrite )
	nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
	nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
	nginx_modules_http_push_stream? ( ssl )
	pcre-jit? ( pcre )
	http2? ( nginx_modules_http_v2 )
	rrd? ( nginx_modules_http_rrd )
	dtls? ( nginx_modules_stream_dtls stream ssl )
	rtmp? ( nginx_modules_core_rtmp )

	nginx_modules_http_pagespeed? ( pcre )
	nginx_modules_http_passenger_enterprise? ( !nginx_modules_http_passenger )
"

IUSE="aio debug +http +http-cache libatomic mail pam +pcre pcre-jit perftools rrd ssl stream threads vim-syntax luajit selinux http2 systemtap dtls rtmp ssl-cert-cb"

NGINX_MODULES_EXT="
	http_passenger
	http_passenger_enterprise
	http_pagespeed
	core_rtmp
	http_nchan
	http_ndk
	stream_lua
	http_lua
	http_lua_upstream
	http_echo
	http_hls_audio
	http_upload_progress
	http_headers_more
	http_push_stream
	http_encrypted_session
	http_cache_purge
	http_redis
	http_python
	stream_python
	http_drizzle
	http_memc
	http_form_input
	http_rds_json
	http_rds_csv
	http_srcache
	http_set_misc
	http_xss
	http_array_var
	http_replace_filter
	http_iconv
	http_postgres
	http_coolkit
	http_supervisord
	http_slowfs_cache
	http_fancyindex
	http_sticky
	http_upstream_check
	http_dyups
	http_upstream_fair
	http_metrics
	http_naxsi
	http_dav_ext
	http_security
	http_auth_pam
	http_rrd
	http_ajp
	http_njs
	http_auth_ldap
	http_ctpp
	http_enmemcache
	core_tcpproxy
	http_rdns
"

for mod in $NGINX_MODULES_STD $NGINX_MODULES_OPT $NGINX_MODULES_3P $NGINX_MODULES_EXT; do
	f=
	[[ "$NGINX_MODULES_STD" =~ "http_${mod//http_}" ]] && f="+"
	IUSE="${IUSE} ${f}nginx_modules_${mod}"
	unset f
done

CDEPEND="
	pam? ( virtual/pam )
	pcre? ( >=dev-libs/libpcre-4.2 )
	pcre-jit? ( >=dev-libs/libpcre-8.20[jit] )
	selinux? ( sec-policy/selinux-nginx )
	ssl? ( dev-libs/openssl:* )
	http-cache? ( userland_GNU? ( dev-libs/openssl:* ) )
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl:* ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )

	perftools? ( dev-util/google-perftools )

	nginx_modules_stream_dtls? (
		>=dev-libs/openssl-1.0.2
	)
"

PDEPEND="
	nginx_modules_http_passenger? ( www-nginx/passenger )
	nginx_modules_http_passenger_enterprise? ( www-nginx/passenger-enterprise )
	nginx_modules_http_pagespeed? ( www-nginx/pagespeed )
	nginx_modules_core_rtmp? ( www-nginx/rtmp )
	nginx_modules_http_nchan? ( www-nginx/nchan )
	nginx_modules_http_ndk? ( www-nginx/ndk )
	nginx_modules_http_lua? ( www-nginx/lua-http )
	nginx_modules_http_lua_upstream? ( www-nginx/lua-upstream )
	nginx_modules_stream_lua? ( www-nginx/lua-stream )
	nginx_modules_http_hls_audio? ( www-nginx/audio-hls )
	nginx_modules_http_upload_progress? ( www-nginx/upload-progress )
	nginx_modules_http_headers_more? ( www-nginx/headers-more )
	nginx_modules_http_encrypted_session? ( www-nginx/headers-more )
	nginx_modules_http_push_stream? ( www-nginx/push-stream )
	nginx_modules_http_cache_purge? ( www-nginx/cache-purge )
	nginx_modules_http_redis? ( www-nginx/redis )
	nginx_modules_http_python? ( www-nginx/python )
	nginx_modules_stream_python? ( www-nginx/python )
	nginx_modules_http_drizzle? ( www-nginx/drizzle )
	nginx_modules_http_memc? ( www-nginx/memc )
	nginx_modules_http_xss? ( www-nginx/xss )
	nginx_modules_http_array_var? ( www-nginx/array-var )
	nginx_modules_http_replace_filter? ( www-nginx/replace-filter )
	nginx_modules_http_iconv? ( www-nginx/iconv )
	nginx_modules_http_coolkit? ( www-nginx/coolkit )
	nginx_modules_http_supervisord? ( www-nginx/supervisord )
	nginx_modules_http_slowfs_cache? ( www-nginx/slowfs )
	nginx_modules_http_fancyindex? ( www-nginx/fancyindex )
	nginx_modules_http_sticky? ( www-nginx/upstream-sticky )
	nginx_modules_http_upstream_check? ( www-nginx/upstream-check )
	nginx_modules_http_dyups? ( www-nginx/upstream-dyups )
	nginx_modules_http_upstream_fair? ( www-nginx/upstream-fair )
	nginx_modules_http_metrics? ( www-nginx/metrics )
	nginx_modules_http_naxsi? ( www-nginx/naxsi )
	nginx_modules_http_dav_ext? ( www-nginx/dav-ext )
	nginx_modules_http_security? ( www-nginx/security )
	nginx_modules_http_auth_pam? ( www-nginx/auth-pam )
	nginx_modules_http_rrd? ( www-nginx/rrd-graph )
	nginx_modules_http_ajp? ( www-nginx/ajp )
	nginx_modules_http_njs? ( www-nginx/njs )
	nginx_modules_http_auth_ldap? ( www-nginx/auth-ldap )
	nginx_modules_http_ctpp? ( www-nginx/ctpp )
	nginx_modules_core_tcpproxy? ( www-nginx/tcp-proxy )
	nginx_modules_http_rdns? ( www-nginx/http-rdns )
	vim-syntax? ( app-vim/nginx-syntax )
"


RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )
"

custom_econf() {
	local EXTRA_ECONF=(${EXTRA_ECONF[@]})
	local ECONF_SOURCE=${ECONF_SOURCE:-.};
	set -- "$@" "${EXTRA_ECONF[@]}"
	echo "${ECONF_SOURCE}/configure" "${@}"
	"${ECONF_SOURCE}/configure" "${@}"
}

pkg_setup() {
	NGINX_HOME="/var/lib/${PN}"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"
	NGINX_CONF_PATH="/etc/${PN}"
	NGINX_MOD_SUBPATH="modules"

	ebegin "Creating nginx user and group"
	enewgroup ${HTTPD_GROUP:-$PN}
	enewuser ${HTTPD_USER:-$PN} -1 -1 "${NGINX_HOME}" ${HTTPD_GROUP:-$PN}
	eend ${?}

	if use nginx_modules_http_lua || use luajit; then
		einfo ""
		einfo "You will probably want to emerge @openresty set"
		einfo ""
	fi

	if use libatomic && ! use arm; then
		ewarn ""
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if you use"
		ewarn "a different compiler or GCC <4.1"
		ewarn ""
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn ""
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is *not supported*!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
		ewarn ""
	fi

	if use !http; then
		ewarn ""
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
		ewarn ""
	fi
}

src_unpack() {
	PORTAGE_QUIET=1 default
	use nginx_modules_stream_dtls && cp "${DISTDIR}/nginx-1.13.0-dtls-experimental.diff" "${S}/"
}

src_prepare() {
	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):'

	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die

	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# Increasing error string (to have possibility to get all modules in nginx -V output)
	sed -i -e "/^#define NGX_MAX_ERROR_STR/s|\(NGX_MAX_ERROR_STR\).*|\1 ${NGINX_MAX_ERROR_LENGTH:-4096}|" "${S}"/src/core/ngx_log.h

	# Increasing maximum dyn modules amount
	sed -i -e "/^#define NGX_MAX_DYNAMIC_MODULES/s|\(NGX_MAX_DYNAMIC_MODULES\).*|\1 ${NGINX_MAX_DYNAMIC_MODULES:-256}|" "${S}"/src/core/ngx_module.c

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done

	use nginx_modules_stream_dtls && PATCHES+=("${S}/nginx-1.13.0-dtls-experimental.diff")

	patches_src_prepare
}

# Kludge to have the possibility to properly check modules
# (ex: dav_ext in DYN makes false positive on dav in OPT)
__NG_M_DYN=${NGINX_MODULES_DYN[@]}
__NG_M_DYN=${__NG_M_DYN// /:}:

opt_mod() {
	local mod="${1}" dyn=
	#if ! use static && [[ "${__NG_M_DYN}" =~ "${mod}:" ]]; then
	if [[ "${__NG_M_DYN}" =~ "${mod}:" ]]; then
		dyn="=dynamic"
	fi
	use "nginx_modules_${mod}" && echo "--with-${mod}_module${dyn}"
}

ext_mod() {
	local mod=${1} p="${2}" dyn=
	if [[ -z "${p}" ]]; then
		# It's Voodoo time!
		p="${mod^^}_MODULE_WD";
		p="${!p}";
	fi
	#if ! use static && [[ "${__NG_M_DYN}" =~ "${mod}:" ]]; then
	if [[ "${__NG_M_DYN}" =~ "${mod}:" ]]; then
		dyn="-dynamic"
	fi
	use "nginx_modules_${mod}" && echo "--add${dyn}-module=${p}"
}

std_mod() {
	use "nginx_modules_${1}" || echo "--without-${1}_module"
}

core_feat() {
	use "${1}" && echo "--with-${2:-${1}}"
}

src_configure() {
	local myconf=()
	local http_enabled= mail_enabled= stream_enabled=
	local http_dyn_lock= stream_dyn_lock= mail_dyn_lock=

	for f in debug libatomic pcre{,-jit} threads; do
		myconf+=($(core_feat "${f}"))
	done
	use aio && myconf+=("$(core_feat aio file-aio)")

	for m in $NGINX_MODULES_STD; do
		local e="$(std_mod ${m})"
		if [[ -z "${e}" ]]; then
			export "${m//_*}_enabled=1"
		else
			myconf+=("${e}")
		fi
	done
	for m in $NGINX_MODULES_OPT; do
		local e="$(opt_mod ${m})"
		if [[ -n "${e}" ]]; then
			export "${m//_*}_enabled=1"
			myconf+=("${e}")
		fi
	done
	for m in $NGINX_MODULES_3P; do
		# TODO: replace this check with a function, if there will be another http+stream-in-one modules
		if [[ "${m}" == "stream_python" ]] && use nginx_modules_http_python; then
			continue
		fi
		local e="$(ext_mod ${m})"
		if [[ -n "${e}" ]]; then
			local proto="${m//_*}"
			if ! [[ "${e}" =~ "-dynamic-" ]]; then
				export "${proto}_dyn_lock=1"
			fi
			export "${proto}_enabled=1"
			myconf+=("${e}")
		fi
	done

	if use http || use http-cache; then
		export http_enabled=1
	fi

	if use mail; then
		export mail_enabled=1
	fi

	if use stream; then
		export stream_enabled=1
	fi

	if [[ -n "${http_enabled}" ]]; then
		use http-cache || myconf+=("--without-http-cache")
		use ssl	&& myconf+=("--with-http_ssl_module")
	else
		myconf+=("--without-http --without-http-cache")
	fi

	use perftools	&& myconf+=("--with-google_perftools_module")

	if [[ -n "${mail_enabled}" ]]; then
		local dyn=
		#if ! use static && [[ -z "${mail_dyn_lock}" ]]; then
		if [[ -z "${mail_dyn_lock}" ]]; then
			dyn="=dynamic"
		fi
		myconf+=("--with-mail${dyn}")
		use ssl && myconf+=("--with-mail_ssl_module")
	fi

	if [[ -n "${stream_enabled}" ]]; then
		local dyn=
		#if ! use static && [[ -z "${stream_dyn_lock}" ]]; then
		if [[ -z "${stream_dyn_lock}" ]]; then
			dyn="=dynamic"
		fi
		myconf+=("--with-stream${dyn}")
		use ssl && myconf+=("--with-stream_ssl_module")
	fi

	# custom static (!) modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=("--add-module=${mod}")
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	if ! use prefix; then
		myconf+=("--user=${HTTPD_USER:-$PN}" "--group=${HTTPD_GROUP:-$PN}")
	fi

	custom_econf \
		--prefix="${EPREFIX}${NGINX_HOME}" \
		--sbin-path="${EPREFIX}/usr/sbin/${PN}" \
		--conf-path="${EPREFIX}/${NGINX_CONF_PATH}/${PN}.conf" \
		--pid-path="${EPREFIX}/run/${PN}.pid" \
		--lock-path="${EPREFIX}/run/lock/${PN}.lock" \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}/var/log/${PN}/access.log" \
		--error-log-path="${EPREFIX}/var/log/${PN}/error.log" \
		--http-client-body-temp-path="tmp/client" \
		--http-proxy-temp-path="tmp/proxy" \
		--http-fastcgi-temp-path="tmp/fastcgi" \
		--http-scgi-temp-path="tmp/scgi" \
		--http-uwsgi-temp-path="tmp/uwsgi" \
		--modules-path="${NGINX_MOD_SUBPATH}" \
		--with-compat \
		"${myconf[@]}" || die "configure failed"

	local sedargs=();
		sedargs+=(-e "s|${WORKDIR}|ext|g")
		sedargs+=(-e 's@(=ext/[^ ]*-)([0-9a-fA-F]{8})[0-9a-fA-F]{32}@\1\2@g')

	sed -i -r "${sedargs[@]}" "${S}/objs/ngx_auto_config.h"

	unset http_enabled mail_enabled stream_enabled http_dyn_lock stream_dyn_lock mail_dyn_lock
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	host-is-pax && pax-mark m "${ED}usr/sbin/${PN}"

	cp "${FILESDIR}/${PN}.conf" "${ED}/etc/${PN}/${PN}.conf" || die

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"

	doman "man/${PN}.8"
	dodoc CHANGES* README
	dodoc contrib/{geo2nginx,unicode2nginx/unicode-to-nginx}.pl

	keepdir /var/www/localhost

	rm -rf "${ED}"/usr/html || die

	# set up a list of directories to keep
	local keepdir_list="${NGINX_HOME_TMP}/client"
	local module
	for module in proxy fastcgi scgi uwsgi; do
		use "nginx_modules_http_${module}" && keepdir_list+=" ${NGINX_HOME_TMP}/${module}"
	done

	keepdir "/var/log/${PN}" ${keepdir_list}

	# a little kludge to ease modules enabling (`load_module modules/moo.so`)
	dosym "../../${NGINX_HOME##/}/modules" "/etc/${PN}/modules"

	# this solves a problem with SELinux where nginx doesn't see the directories
	# as root and tries to create them as nginx
	fperms 0750 "${NGINX_HOME_TMP}"
	fowners "${HTTPD_USER:-${PN}}:0" "${NGINX_HOME_TMP}"

	fperms 0700 "/var/log/${PN}" ${keepdir_list}
	fowners "${HTTPD_USER:-${PN}}:${HTTPD_GROUP:-${PN}}" "/var/log/${PN}" ${keepdir_list}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

# http_perl
	if use nginx_modules_http_perl; then
		pushd "${S}/objs/src/http/modules/perl" &>/dev/null
		emake DESTDIR="${D}" INSTALLDIRS=vendor install || die "failed to install perl stuff"
		perl_delete_localpod
		popd &>/dev/null
	fi

	#find "${S}/objs" -type f -and '(' -name '*.o' -or -name '*.so' -or -executable ')' -delete
	emake clean
	mkdir -p "${D}/usr/src/${PN}"
	cp -a "${S}" "${D}/usr/src/${PN}"

	for m in $(find "${D}/${NGINX_HOME}/${NGINX_MOD_SUBPATH}" -name '*.so'); do
		echo "load_module ${NGINX_HOME}/${NGINX_MOD_SUBPATH}/$(basename ${m});" >> "${T}/nginx_bundled.conf"
	done

	keepdir "${NGINX_CONF_PATH}"/modules.d
	insinto "${NGINX_CONF_PATH}"/modules.d
	doins "${T}/nginx_bundled.conf"
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${EROOT}"/etc/ssl/"${PN}"/"${PN}".key ]; then
			install_cert /etc/ssl/"${PN}"/"${PN}"
			use prefix || chown "${HTTPD_USER:-$PN}":"${HTTPD_GROUP:-$PN}" "${EROOT}"/etc/ssl/"${PN}"/"${PN}".{crt,csr,key,pem}
		fi
	fi

	if use nginx_modules_http_lua && use nginx_modules_http_v2; then
		ewarn ""
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua v2\". For more info, see http://git.io/OldLsg"
	fi

	# If the nginx user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c 'cd /var/log/${PN}/ && ls' "${HTTPD_USER:-$PN}" >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn ""
		ewarn "Please make sure that the nginx user (${HTTPD_USER:-$PN}) or group (${HTTPD_GROUP:-$PN}) has at least"
		ewarn "'rx' permissions on /var/log/${PN} (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi
}

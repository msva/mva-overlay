# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

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

# http_headers_more (http://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.13"
HTTP_HEADERS_MORE_MODULE_P="ngx-http-headers-more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_SHA1="9508330"

# http_passenger (http://www.modrails.com/, MIT license)
# TODO: currently builds some stuff in src_configure
PASSENGER_PV="3.0.7"
USE_RUBY="ruby18"
RUBY_OPTIONAL="yes"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.692"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="1.2"
HTTP_CACHE_PURGE_MODULE_P="ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# HTTP Upload module from Valery Kholodkov
# (http://www.grid.net.ru/nginx/upload.en.html, BSD license)
HTTP_UPLOAD_MODULE_PV="2.2.0"
HTTP_UPLOAD_MODULE_P="nginx_upload_module-${HTTP_UPLOAD_MODULE_PV}"

# ey-balancer/maxconn module (https://github.com/ry/nginx-ey-balancer, as-is)
HTTP_EY_BALANCER_MODULE_PV="0.0.6"
HTTP_EY_BALANCER_MODULE_P="nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_PV}"
HTTP_EY_BALANCER_MODULE_SHA1="d373670"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.5"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

CHUNKIN_MODULE_PV="0.22rc1"
CHUNKIN_MODULE_SHA1="b0a3ee3"

inherit eutils ssl-cert toolchain-funcs perl-module ruby-ng flag-o-matic

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://sysoev.ru/nginx/
	http://www.modrails.com/
	http://pushmodule.slact.net/
	http://labs.frickle.com/nginx_ngx_cache_purge/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz
	nginx_modules_http_headers_more? ( http://github.com/agentzh/headers-more-nginx-module/tarball/v${HTTP_HEADERS_MORE_MODULE_PV} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? ( mirror://rubyforge/passenger/passenger-${PASSENGER_PV}.tar.gz )
	nginx_modules_http_push? ( http://pushmodule.slact.net/downloads/${HTTP_PUSH_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( http://labs.frickle.com/files/${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_upload? ( http://www.grid.net.ru/nginx/download/${HTTP_UPLOAD_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( https://github.com/ry/nginx-ey-balancer/tarball/v${HTTP_EY_BALANCER_MODULE_PV} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( http://labs.frickle.com/files/${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	pam? ( http://web.iti.upv.es/~sto/nginx/ngx_http_auth_pam_module-1.1.tar.gz )
	rrd? ( http://wiki.nginx.org/images/9/9d/Mod_rrd_graph-0.2.0.tar.gz )
	chunk? ( http://github.com/agentzh/chunkin-nginx-module/tarball/v${CHUNKIN_MODULE_PV} -> chunkin-nginx-module-${CHUNKIN_MODULE_PV}.tgz )"

LICENSE="BSD BSD-2 GPL-2 MIT
	pam? ( as-is )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip limit_req limit_zone map memcached proxy referer rewrite scgi ssi
split_clients upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition dav degradation flv geoip gzip_static image_filter
perl random_index realip secure_link stub_status sub xslt"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="http_cache_purge http_headers_more http_passenger http_push
http_upload http_ey_balancer http_slowfs_cache"

IUSE="aio chunk debug +http +http-cache ipv6 libatomic pam +pcre perftools rrd ssl vim-syntax"

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
	nginx_modules_http_image_filter? ( media-libs/gd )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
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

pkg_setup() {
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}

	if use ipv6; then
		ewarn "Note that ipv6 support in nginx is still experimental."
		ewarn "Be sure to read comments on gentoo bug #274614"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=274614"
	fi

	if use libatomic; then
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use nginx_modules_http_passenger; then
		ruby-ng_pkg_setup
		use debug && append-flags -DPASSENGER_DEBUG
	fi

	if use !http; then
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
	use pam && unpack "ngx_http_auth_pam_module-1.1.tar.gz"
	use rrd && unpack "Mod_rrd_graph-0.2.0.tar.gz"
	use chunk && unpack "chunkin-nginx-module-${CHUNKIN_MODULE_PV}.tgz"
}

src_prepare() {
	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make

	if use nginx_modules_http_ey_balancer; then
		epatch "${FILESDIR}"/nginx-0.8.32-ey-balancer.patch
	fi

	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-"${PASSENGER_PV}";

		epatch "${FILESDIR}"/passenger-3.0.0-gentoo.patch
		epatch "${FILESDIR}"/passenger-3.0.0-ldflags.patch

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

	if use nginx_modules_http_fastcgi; then
		myconf="${myconf} --with-http_realip_module"
	fi

	# third-party modules
	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/agentzh-headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_SHA1}"
	fi

	if use nginx_modules_http_passenger; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/passenger-${PASSENGER_PV}/ext/nginx"
	fi

	if use nginx_modules_http_push; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_P}"
	fi

	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"
	fi

	if use nginx_modules_http_upload; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/${HTTP_UPLOAD_MODULE_P}"
	fi

	if use nginx_modules_http_ey_balancer; then
		http_enabled=1
		myconf="${myconf} --add-module=${WORKDIR}/ry-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"
	fi

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

	use perftools && myconf="${myconf}  --with-google_perftools_module"
	use rrd && myconf="${myconf} --add-module="${WORKDIR}"/mod_rrd_graph-0.2.0"
	use chunk	&& myconf="${myconf} \
						--add-module="${WORKDIR}"/agentzh-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1}"
	use pam && myconf="${myconf} --add-module="${WORKDIR}"/ngx_http_auth_pam_module-1.1"

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
		--conf-path=/etc/${PN}/${PN}.conf \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--lock-path=/var/lock/nginx.lock \
		--user=${PN} --group=${PN} \
		--with-cc-opt="-I${ROOT}usr/include" \
		--with-ld-opt="-L${ROOT}usr/lib" \
		--http-log-path=/var/log/${PN}/access_log \
		--http-client-body-temp-path=/var/tmp/${PN}/client \
		--http-proxy-temp-path=/var/tmp/${PN}/proxy \
		--http-fastcgi-temp-path=/var/tmp/${PN}/fastcgi \
		--http-scgi-temp-path=/var/tmp/${PN}/scgi \
		--http-uwsgi-temp-path=/var/tmp/${PN}/uwsgi \
		${myconf} || die "configure failed"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi,scgi,uwsgi}

	dosbin objs/nginx
	newinitd "${FILESDIR}"/nginx.init-r2 nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf
	rm conf/win-utf conf/koi-win conf/koi-utf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	doman man/nginx.8
	dodoc CHANGES* README

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx

	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		fixlocalpod
	fi

	if use nginx_modules_http_push; then
		docinto ${HTTP_PUSH_MODULE_P}
		dodoc "${WORKDIR}"/${HTTP_PUSH_MODULE_P}/{changelog.txt,protocol.txt,README}
	fi

	if use nginx_modules_http_cache_purge; then
		docinto ${HTTP_CACHE_PURGE_MODULE_P}
		dodoc "${WORKDIR}"/${HTTP_CACHE_PURGE_MODULE_P}/{CHANGES,README}
	fi

	if use nginx_modules_http_upload; then
		docinto ${HTTP_UPLOAD_MODULE_P}
		dodoc "${WORKDIR}"/${HTTP_UPLOAD_MODULE_P}/{Changelog,README}
	fi

	if use nginx_modules_http_ey_balancer; then
		docinto ${HTTP_EY_BALANCER_MODULE_P}
		dodoc "${WORKDIR}"/${HTTP_EY_BALANCER_MODULE_P}/README
	fi

	if use nginx_modules_http_slowfs_cache; then
		docinto ${HTTP_SLOWFS_CACHE_MODULE_P}
		dodoc "${WORKDIR}"/${HTTP_SLOWFS_CACHE_MODULE_P}/{CHANGES,README.md}
	fi

	if use nginx_modules_http_passenger; then
		cd "${WORKDIR}"/passenger-${PASSENGER_PV}
		rake fakeroot
	fi

	use chunk   && newdoc "${WORKDIR}/agentzh-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1}"/README README.chunkin
	use pam && newdoc "${WORKDIR}"/ngx_http_auth_pam_module-1.1/README README.pam
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	fi
}

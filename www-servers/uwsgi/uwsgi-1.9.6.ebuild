# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/uwsgi/uwsgi-1.9.6.ebuild,v 1.1 2013/04/20 00:31:37 zx2c4 Exp $

EAPI="5"
PYTHON_DEPEND="python? *"
PYTHON_MODNAME="uwsgidecorators"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"
USE_RUBY="ruby18 ree18 ruby19"
RUBY_OPTIONAL="yes"
PHP_EXT_NAME="dummy"
PHP_EXT_INI="no"
USE_PHP="php5-3 php5-4" # deps must be registered separately below
PHP_EXT_OPTIONAL_USE="php"

MY_P="${P/_/-}"

inherit apache-module eutils python multilib pax-utils php-ext-source-r2 ruby-ng versionator

DESCRIPTION="uWSGI server for Python web applications"
HOMEPAGE="http://projects.unbit.it/uwsgi/"
SRC_URI="http://projects.unbit.it/downloads/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="apache2 +caps +carbon cgi debug erlang gevent graylog2 json ldap lua luajit +nagios pam perl +pcre php probepg +python rrdtool rsyslog ruby spooler sqlite syslog +xml yaml zeromq"
REQUIRED_USE="|| ( cgi erlang lua perl php python ruby )"

# util-linux is required for libuuid when requesting zeromq support
CDEPEND="caps? ( sys-libs/libcap )
	json? ( dev-libs/jansson )
	erlang? ( dev-lang/erlang )
	gevent? ( >=dev-python/gevent-1.0_beta2 )
	graylog2? ( sys-libs/zlib )
	ldap? ( net-nds/openldap )
	lua? ( !luajit? ( dev-lang/lua ) )
	luajit? ( dev-lang/luajit )
	pcre? ( dev-libs/libpcre )
	perl? ( dev-lang/perl )
	php? (
		php_targets_php5-3? ( dev-lang/php:5.3[embed] )
		php_targets_php5-4? ( dev-lang/php:5.4[embed] )
	)
	probepg? ( dev-db/postgresql-base:= )
	ruby? ( $(ruby_implementations_depend) )
	sqlite? ( dev-db/sqlite:3 )
	rsyslog? ( app-admin/rsyslog )
	xml? ( dev-libs/libxml2 )
	yaml? ( dev-libs/libyaml )
	zeromq? ( net-libs/zeromq sys-apps/util-linux )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	rrdtool? ( net-analyzer/rrdtool )"

S="${WORKDIR}/${MY_P}"
APXS2_S="${S}/apache2"
APACHE2_MOD_CONF="42_mod_uwsgi-r1 42_mod_uwsgi"

want_apache2_2

use_true_false() {
	if use $1 ; then
		echo "true"
	else
		echo "false"
	fi
}

src_unpack() {
	default
}

pkg_setup() {
	depend.apache_pkg_setup
	python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}/1.1.2-threaded-php.patch"

	sed -i \
		-e "s|'-O2', ||" \
		-e "s|'-Werror', ||" \
		-e "s|uc.get('plugin_dir')|uc.get('plugin_build_dir')|" \
		uwsgiconfig.py || die "sed failed"

	sed -i \
		-e 's|python\([0-9].[0-9]\)-config|python-config-\1|' \
		plugins/python/uwsgiplugin.py || die "sed failed"

	sed -i \
		-e "s|/lib|/$(get_libdir)|" \
		plugins/php/uwsgiplugin.py || die "sed failed"
}

src_configure() {
	local plugins=""
	use carbon && plugins+=", carbon"
	use graylog2 && plugins+=", graylog2"
	use nagios && plugins+=", nagios"
	use pam && plugins+=", pam"
	use rrdtool && plugins+=", rrdtool"
	use rsyslog && plugins+=", rsyslog"
	use syslog && plugins+=", syslog"

	# Notes:
	# * the embedded_plugins mostly follows the list of embedded_plugins
	#   in buildconf/base.ini, make sure you compare the list when bumping uWSGI
	# * thus: keep the order in embedded_plugins the same as in the base.ini
	cat > "buildconf/gentoo.ini" << EOF
[uwsgi]
xml = $(use_true_false xml)
ini = true
yaml = $(use_true_false yaml)
json = $(use_true_false json)
sqlite3 = $(use_true_false sqlite)
zeromq = $(use_true_false zeromq)
snmp = true
sctp = false
spooler = true
embedded = true
ssl = auto
udp = true
multicast = true
threading = true
sendfile = true
minterpreters = true
async = true
evdis = false
ldap = $(use_true_false ldap)
pcre = $(use_true_false pcre)
routing = auto
alarm = auto
debug = $(use_true_false debug)
unbit = false
xml_implementation = libxml2
yaml_implementation = libyaml
malloc_implementation = libc
plugins =
bin_name = uwsgi
append_version =
plugin_dir = /usr/$(get_libdir)/uwsgi
plugin_build_dir = ${T}/plugins
embedded_plugins =  ping, cache, rpc, corerouter, fastrouter, http, ugreen, signal, logsocket, router_uwsgi, router_redirect, router_basicauth, zergpool, redislog, mongodblog, router_rewrite, router_http, logfile, router_cache, rawrouter ${plugins}
as_shared_library = false

locking = auto
event = auto
timer = auto
filemonitor = auto

embed_files =

embed_config =
[python]
paste = true
web3 = true
EOF
	use caps || sed -i -e 's|sys/capability.h|DISABLED|' uwsgiconfig.py || die "sed failed"
	use zeromq || sed -i -e 's|uuid/uuid.h|DISABLED|' uwsgiconfig.py || die "sed failed"

	if use probepg ; then
		PGPV="$(best_version dev-db/postgresql-base)"
		PGSLOT="$(get_version_component_range 1-2 ${PGPV##dev-db/postgresql-base-})"
		sed -i \
			-e "s|pg_config|pg_config${PGSLOT/.}|" \
			plugins/probepg/uwsgiplugin.py || die "sed failed"
	fi
}

each_ruby_compile() {
	cd "${WORKDIR}/${MY_P}"

	UWSGICONFIG_RUBYPATH="${RUBY}" python uwsgiconfig.py --plugin plugins/rack gentoo rack_${RUBY##*/} || die "building plugin for ${RUBY} failed"

	if [[ "${RUBY}" == *ruby19 ]] ; then
		UWSGICONFIG_RUBYPATH="${RUBY}" python uwsgiconfig.py --plugin plugins/fiber gentoo || die "building fiber plugin for ${RUBY} failed"
	fi
}

install_python_lib() {
	insinto $(python_get_sitedir)
	doins uwsgidecorators.py
}

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;

	python uwsgiconfig.py --build gentoo || die "building uwsgi failed"

	mkdir -p "${T}/plugins"

	if use erlang ; then
		python uwsgiconfig.py --plugin plugins/erlang gentoo || die "building plugin for erlang failed"
	fi

	if use lua ; then
		# setting LUALIB explicitly since lua is not slotted on Gentoo
		# and uwsgi otherwise looks for lua5.1
		UWSGICONFIG_LUALIB="${lua}" python uwsgiconfig.py --plugin plugins/lua gentoo || die "building plugin for lua failed"
	fi

	if use perl ; then
		python uwsgiconfig.py --plugin plugins/psgi gentoo || die "building plugin for perl failed"
	fi

	if use php ; then
		for s in $(php_get_slots); do
			UWSGICONFIG_PHPDIR="/usr/$(get_libdir)/${s}" python uwsgiconfig.py --plugin plugins/php gentoo ${s/.} || die "building plugin for ${s} failed"
		done
	fi

	if use python ; then
		for a in ${PYTHON_ABIS} ; do
			python${a} uwsgiconfig.py --plugin plugins/python gentoo python${a/.} || die "building plugin for python-${a} failed"

			if use gevent ; then
				python${a} uwsgiconfig.py --plugin plugins/gevent gentoo gevent${a/.} || die "building plugin for gevent-support in python-${a} failed"
			fi
			if use erlang ; then
				python${a} uwsgiconfig.py --plugin plugins/pyerl gentoo pyerl${a/.} || die "building plugin for erlang-support in python failed"
			fi
		done
	fi

	if use ruby ; then
		ruby-ng_src_compile
	fi

	if use spooler ; then
		python uwsgiconfig.py --plugin plugins/spooler gentoo || die "building plugin for spooler failed"
	fi

	if use cgi ; then
		python uwsgiconfig.py --plugin plugins/cgi gentoo || die "building plugin for cgi failed"
	fi

	if use probepg ; then
		python uwsgiconfig.py --plugin plugins/probepg gentoo || die "building plugin for postgresql probe failed"
	fi

	if use apache2 ; then
		for m in proxy_uwsgi Ruwsgi uwsgi ; do
			APXS2_ARGS="-c mod_${m}.c"
			apache-module_src_compile
		done
	fi
}

src_install() {
	dobin uwsgi
	pax-mark m "${D}"/usr/bin/uwsgi

	insinto /usr/$(get_libdir)/uwsgi
	doins "${T}/plugins"/*.so

	use cgi && dosym uwsgi /usr/bin/uwsgi_cgi
	use erlang && dosym uwsgi /usr/bin/uwsgi_erlang
	use lua && dosym uwsgi /usr/bin/uwsgi_lua
	use luajit && dosym uwsgi /usr/bin/uwsgi_luajit
	use perl && dosym uwsgi /usr/bin/uwsgi_psgi

	if use php ; then
		for s in $(php_get_slots); do
			dosym uwsgi /usr/bin/uwsgi_${s/.}
		done
	fi

	if use python ; then
		python_execute_function install_python_lib
		for a in ${PYTHON_ABIS} ; do
			dosym uwsgi /usr/bin/uwsgi_python${a/.}
		done
	fi

	if use apache2; then
		for m in proxy_uwsgi Ruwsgi uwsgi ; do
			APACHE2_MOD_FILE="${APXS2_S}/.libs/mod_${m}.so"
			apache-module_src_install
		done
	fi

	newinitd "${FILESDIR}"/uwsgi.initd-r3 uwsgi
	newconfd "${FILESDIR}"/uwsgi.confd-r3 uwsgi
	keepdir /etc/"${PN}".d
	use spooler && keepdir /var/spool/"${PN}"
}

pkg_postinst() {
	if use apache2 ; then
		elog "Three Apache modules have been installed: mod_proxy_uwsgi, mod_uwsgi and mod_Ruwsgi."
		elog "You can enable them with -D PROXY_UWSGI, -DUWSGI or -DRUWSGI in /etc/conf.d/apache2."
		elog "mod_uwsgi and mod_Ruwsgi have the same configuration interface and define the same symbols."
		elog "Therefore you can enable only one of them at a time."
		elog "mod_uwsgi is commercially supported by Unbit and stable but a bit hacky."
		elog "mod_Ruwsgi is newer and more Apache-API friendly but not commercially supported."
		elog "mod_proxy_uwsgi is the newest and not considered ready for production yet."
	fi

	elog "Append the following options to the uwsgi call to load the respective language plugin:"
	use cgi    && elog "  '--plugins cgi' for cgi"
	use erlang && elog "  '--plugins erlang' for erlang"
	use lua    && elog "  '--plugins lua' for lua"
	use perl   && elog "  '--plugins psgi' for perl"

	if use php ; then
		for s in $(php_get_slots); do
			elog "  '--plugins ${s/.}' for ${s}"
		done
	fi

	if use python ; then
		for a in ${PYTHON_ABIS} ; do
			elog "  '--plugins python${a/.}' for python-${a}"
			use gevent && elog "  '--plugins python${a/.},gevent${a/.}' for gevent support in python-${a}"
			use erlang && elog "  '--plugins python${a/.},erlang,pyerl${a/.}' for erlang support in python-${a}"
		done
	fi

	if use ruby ; then
		for ruby in $USE_RUBY; do
			use ruby_targets_${ruby} && elog "  '--plugins rack_${ruby/.}' for ${ruby}"
			if [[ "${ruby}" == *ruby19 ]] ; then
				elog "  '--plugins fibre' for ruby-1.9 fibres"
			fi
		done
	fi
}

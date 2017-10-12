# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# mva
# @AUTHOR:
# mva
# @BLURB:
# @DESCRIPTION:
# Eclass for ease the creation of NginX dynamic modules ebuilds.

case ${VCS} in
	git)
		VCS="git-r3"
		;;
	hg)
		VCS="mercurial"
		;;
	svn)
		VCS="subversion"
		;;
esac

inherit ${VCS} toolchain-funcs flag-o-matic eutils pax-utils multilib patches

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install
case "${EAPI:-0}" in
	6) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

[[ -n "${GITHUB_A}" && -n "${BITBUCKET_A}" ]] && die "Only one of GITHUB_A or BITBUCKET_A should be set!"
if [[ -n "${GITHUB_A}" ]]; then
	PKG_PN="${GITHUB_PN:-${PN}}"
	PKG_PV="${GITHUB_PV:-${GITHUB_SHA:-${PV}}}"
	EVCS_A="https://github.com/${GITHUB_A}"
	DL="archive"
elif [[ -n "${BITBUCKET_A}" ]]; then
	PKG_PN="${BITBUCKET_PN:-${PN}}"
	PKG_PV="${BITBUCKET_PV:-${PV}}"
	EVCS_A="https://bitbucket.org/${BITBUCKET_A}"
	DL="get"
else
	PKG_PN="${PKG_PN:-${PN}}"
	PKG_PV="${PKG_PV:-${PV}}"
fi
if [[ -z "${EGIT_REPO_URI}" && -z "${EHG_REPO_URI}" && -z "${SRC_URI}" && -n "${EVCS_A}" ]]; then
	EVCS_URI="${EVCS_A}/${PKG_PN}"
	if [[ "${VCS}" = git* ]]; then
		EGIT_REPO_URI="${EVCS_URI}"
	elif [[ "${VCS}" = "mercurial" ]]; then
		EHG_REPO_URI="${EVCS_URI}"
	elif [[ -z "${VCS}" && "${PV}" != *9999* ]]; then
		SRC_URI="${EVCS_URI}/${DL}/${PKG_PV}.tar.gz -> nginx.${P}.tar.gz"
	fi
fi

#NG_MOD_V=${NG_MOD_V:-${PV}}
NG_MOD_V=${NG_MOD_V:-${GITHUB_SHA:-${PV}}}
NG_MOD_WD="${WORKDIR}/${NG_MOD_PREFIX}${NG_MOD_NAME:-${PKG_PN}}${NG_MOD_V:+-}${NG_MOD_V}${NG_MOD_SUFFIX}"
S="${WORKDIR}/nginx"
CDEPEND="www-servers/nginx:mainline"
if [[ -n "${NDK}" ]]; then
	CDEPEND="${CDEPEND} www-nginx/ndk"
fi

ng_dohdr() {
	insinto "${EROOT}/usr/include/nginx/${PN}"
	doins ${*}
}

ngeconf() {
	debug-print-function ${FUNCNAME} "$@"
	local EXTRA_ECONF=(${EXTRA_ECONF[@]})
	local ECONF_SOURCE=${ECONF_SOURCE:-.};
	set -- "$@" "${EXTRA_ECONF[@]}"
	echo "${ECONF_SOURCE}/configure" "${@}"
	"${ECONF_SOURCE}/configure" "${@}"
}

# @FUNCTION: nginx-module_pkg_setup
# @DESCRIPTION:
# Exported function running the checks and exporting modules path.
nginx-module_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	has_version www-servers/nginx || die "NginX is not installed (but is needed for modules to work)"
	export NGINX_CONFIGURE_OPTS=$(/usr/sbin/nginx -V 2>&1 | sed -r -n -e '/configure arguments:/{s@configure arguments: (.*)@\1@;s@--add[^ ]*module=[^ ]* @@g;p}')
	export NGINX_MOD_PATH=$(echo ${NGINX_CONFIGURE_OPTS} | sed -r -n -e '/modules/{s@.*--prefix=([^ ]*) .*--modules-path=([^ ]*) .*@\1/\2@;p}')
	export NGINX_CONF_PATH=$(dirname $(echo ${NGINX_CONFIGURE_OPTS} | sed -r -n -e '/conf-path/{s@.*--conf-path=([^ ]*) .*@\1@;p}'))

	if declare -f nginx-module-setup &>/dev/null; then
		nginx-module-setup
	fi
}

nginx-module_src_unpack() {
	if declare -f nginx-module-unpack &>/dev/null; then
		nginx-module-unpack
	else
		if [[ -n ${VCS} ]]; then
			${VCS}_src_unpack
		else
			default
		fi
	fi

	cp -a /usr/src/nginx/* "${S}"
}

nginx-module_src_prepare() {
	pushd "${NG_MOD_WD}" &>/dev/null
		patches_src_prepare
		if [[ -n "${NDK}" ]]; then
			sed -r \
				-e '1iNDK_SRCS="ndk.c"' \
				-i config || die
			NG_MOD_DEFS+=("NDK")
			NG_MOD_DEPS+=("ndk")
		fi
		if declare -f nginx-module-prepare &>/dev/null; then
			nginx-module-prepare
		fi
		for pk in ${NG_MOD_DEPS[@]}; do
			append-cflags "-I/usr/include/nginx/${pk}"
		done;
		for def in ${NG_MOD_DEFS[@]}; do
			append-cflags "-D${def}"
		done
	popd &>/dev/null
}

nginx-module_src_configure() {
	debug-print-function ${FUNCNAME} "$@"
	local myconf=()
	export LANG=C LC_ALL=C
	tc-export CC

	if declare -f nginx-module-configure &>/dev/null; then
		pushd "${NG_MOD_WD}" &>/dev/null
		nginx-module-configure
		popd &>/dev/null
	fi

	ngeconf \
		${NGINX_CONFIGURE_OPTS} \
		"${myconf[@]}" \
		--with-compat \
		--add-dynamic-module="${NG_MOD_WD}" \
		|| die "configure failed"
}

nginx-module_src_compile() {
	debug-print-function ${FUNCNAME} "$@"
	if declare -f nginx-module-compile &>/dev/null; then
		pushd "${NG_MOD_WD}" &>/dev/null
		nginx-module-compile
		popd &>/dev/null
	fi

	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

nginx-module_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	insinto "${NGINX_MOD_PATH}"
	for m in ${NG_MOD_LIST[@]}; do
		doins "objs/${m}"
		echo "load_module ${NGINX_MOD_PATH}/${m};" >> "${T}/${PN}.conf"
	done

	keepdir "${NGINX_CONF_PATH}"/modules.d
	insinto "${NGINX_CONF_PATH}"/modules.d
	doins "${T}/${PN}.conf"

	if declare -f nginx-module-install &>/dev/null; then
		pushd "${NG_MOD_WD}" &>/dev/null
		nginx-module-install
		popd &>/dev/null
	fi

	einstalldocs
}

nginx-module_src_postinst() {
	if declare -f nginx-module-postinst &>/dev/null; then
		nginx-module-postinst
	fi

	for m in ${NG_MOD_LIST[@]}; do
		host-is-pax && pax-mark m "${NGINX_MOD_PATH}/${m}"
	done

	einfo "Don't forget to add 'include modules.d/${PN}.conf;' in your nginx.conf"

	if [[ -n "${NDK}" ]]; then
		ewarn "This module require that ndk module would also be loaded."
		ewarn "Please, make sure ndk module is also loaded ('include modules.d/<modname>.conf;')."
	fi
}

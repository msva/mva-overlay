# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="CryptoPro Browser Plugin (with additional bundled stuff)"

SRC_URI="
	x86? ( ${P}_x86.tar.gz )
	amd64? ( ${P}_amd64.tar.gz )
	arm64? ( ${P}_arm64.tar.gz )
"
# ${P}_${ARCH}.tar.gz
# pkgdev doesn't support ${ARCH} ATM and throws an error
#	arm? ( ${P}_arm.tar.gz )
# ^ can't figure out what would be proper user-agennt to download it to generate manifest.
# Help wanted.

HOMEPAGE="https://cryptopro.ru/products/csp/downloads"
LICENSE="Crypto-Pro"
RESTRICT="bindist fetch mirror strip"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# ~arm

RDEPEND="
	app-crypt/cprocsp
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/rpm"

QA_PREBUILT="opt/cprocsp/*"

_get_arch() {
	if [[ -n "${_got_arch}" ]]; then
		echo ${_got_arch};
		return
	fi
	local _got_arch
	case $(uname -m) in
		x86_64)
			_got_arch="amd64"
			;;
		i*86)
			_got_arch="ia32"
			;;
		armv7*)
			_got_arch="armhf"
			;;
		aarch64)
			_got_arch="arm64"
			;;
	esac
	export _got_arch
	echo "${_got_arch}"
}

pkg_nofetch() {
	local PLUGIN_URL="https://cryptopro.ru/products/cades/plugin/get_2_0"
	einfo "Please, open this link in the browser: ${PLUGIN_URL}"
	einfo "(registration/login needed)"
	einfo "Then download it and place it at ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	ewarn "Post an issue on GH in case of checksums mismatch"
}

src_unpack() {
	local uname_m=$(uname -m)
	local arch=$(_get_arch)
	default
	mkdir -p "${S}"
	cd "${S}"
	PKGS=( # Plugin
		cprocsp-pki-plugin
	)
	ADD_PKGS=( # Additional packages
		cprocsp-pki-cades
		cprocsp-pki-phpcades
	)
	for f in ${PKGS[@]} ${ADD_PKGS[@]}; do
		local a=${arch}
		[[ "${arch}" == "arm64" ]] && a="aarch64"
		# dunno why they named it arm64 everywhere (including debs), but rpms are named aarch64
		find "../cades-linux-${arch}" -name "${f}*${a}.rpm" | while read r; do rpm_unpack "./${r}"; done
	done
}

#src_prepare() {
#	default
#}

src_install() {
	insinto /
	doins -r opt etc usr
	exeinto /opt/cprocsp/bin/amd64
	doexe opt/cprocsp/bin/amd64/*
	# exeinto /opt/cprocsp/sbin/amd64
	# doexe opt/cprocsp/sbin/amd64/*
	exeinto /opt/cprocsp/lib/amd64
	doexe opt/cprocsp/lib/amd64/*
}

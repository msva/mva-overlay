# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="CryptoPro Browser Plugin (with additional bundled stuff)"
HOMEPAGE="https://cryptopro.ru/products/csp/downloads"

BASE_SRC_URI="https://cryptopro.ru/sites/default/files/products/cades/current_release_2_0/cades-linux"
SRC_URI="
	x86? ( ${BASE_SRC_URI}-ia32.tar.gz -> ${P}_x86.tar.gz )
	amd64? ( ${BASE_SRC_URI}-amd64.tar.gz -> ${P}_amd64.tar.gz )
	arm64? ( ${BASE_SRC_URI}-arm64.tar.gz -> ${P}_arm64.tar.gz )
	arm? ( ${BASE_SRC_URI}-armhf.tar.gz -> ${P}_arm.tar.gz )
	mips? ( ${BASE_SRC_URI}-mipsel.tar.gz -> ${P}_mipsel.tar.gz )
"
# ${P}_${ARCH}.tar.gz
# pkgdev doesn't support ${ARCH} ATM and throws an error

LICENSE="Crypto-Pro"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-crypt/cprocsp
	!>=app-crypt/cprocsp-5.0.12900
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
		mips*)
			_got_arch="mipsel"
			;;
	esac
	export _got_arch
	echo "${_got_arch}"
}

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
		ewarn "If you will get checksums mismatch then upstream, probably discontinued separate 'browser plugin' packages"
		ewarn "Upgrade app-crypt/cprocsp to >= 5.0.12900 (it includes browser plugin)"
		ewarn "Also, place an issue on overlay's issue tracker on GitHub, please"
	fi
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
		find "../cades-linux-${arch}" -name "${f}*${a}.rpm" | while read r; do rpm_unpack "./${r}"; done
	done
}

#src_prepare() {
#	default
#}

src_install() {
	local arch=$(_get_arch)
	insinto /
	doins -r opt etc usr
	exeinto /opt/cprocsp/bin/"${arch}"
	doexe opt/cprocsp/bin/"${arch}"/*
	# exeinto /opt/cprocsp/sbin/amd64
	# doexe opt/cprocsp/sbin/amd64/*
	exeinto /opt/cprocsp/lib/"${arch}"
	doexe opt/cprocsp/lib/"${arch}"/*
}

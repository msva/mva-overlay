# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="CryptoPro Browser Plugin (with additional bundled stuff)"

SRC_URI="${P}_${ARCH}.tar.gz"

HOMEPAGE="https://cryptopro.ru/products/csp/downloads"
LICENSE="Crypto-Pro"
RESTRICT="fetch mirror strip"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

RDEPEND="
	>=sys-apps/pcsc-lite-1.4.99
	virtual/libusb:0
	sys-apps/dbus
	media-libs/libpng:0
	media-libs/fontconfig
	>=dev-libs/libp11-0.4.0
	media-libs/hal-flash
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
		find "../cades-linux-${arch}" -name "${f}*${arch}.rpm" | while read r; do rpm_unpack "./${r}"; done
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

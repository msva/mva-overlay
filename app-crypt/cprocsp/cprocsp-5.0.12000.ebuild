# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="CryptoPro Crypto Provider"

SRC_URI="${P}_${ARCH}.tgz"

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
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/rpm2targz"

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
	local BASE_URL="https://cryptopro.ru/sites/default/files/private/csp"
	local v=$(ver_cut 1-2)
	local arch=$(_get_arch)
	einfo "Please, open this link in the browser: ${BASE_URL}/${v//.}/$(ver_cut 3)/linux-${arch}.tgz"
	einfo "(registration/login needed)"
	einfo "Then download it and place it at ${PORTAGE_ACTUAL_DISTDIR}/${A}"
}

src_unpack() {
	local uname_m=$(uname -m)
	local arch=$(_get_arch);
	default
	mkdir -p "${S}"
	cd "${S}"
	PKGS=( # Packages that usually installed by CryptoPro installer
		lsb-cprocsp-{base,rdr,kc1,capilite,ca-certs,pkcs11}
		cprocsp-{curl,rdr}
	)
	ADD_PKGS=( # Additional packages that should be useful (token drivers, patched stunnel, cert viewer)
		lsb-cprocsp-rcrypt
		cprocsp-{stunnel,xer2print,cptools}
		cprocsp-ipsec-{genpsk,ike}
		ifd-rutokens
	)
	for f in ${PKGS[@]} ${ADD_PKGS[@]}; do
		find "../linux-${arch}" -name "${f}*.rpm" | while read r; do rpm_unpack "./${r}"; done
	done
	mv tmp opt/cprocsp
	mv etc/udev usr/lib/udev
}

#src_prepare() {
#	default
#}

src_install() {
	insinto /
	doins -r opt etc usr var
	exeinto /opt/cprocsp/bin/amd64
	doexe opt/cprocsp/bin/amd64/*
	exeinto /opt/cprocsp/sbin/amd64
	doexe opt/cprocsp/sbin/amd64/*
	exeinto /opt/cprocsp/lib/amd64
	doexe opt/cprocsp/lib/amd64/*
}

pkg_postinst() {
	echo -n # TODO: a bunch of cpconfig commands
}


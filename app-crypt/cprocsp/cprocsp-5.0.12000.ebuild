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
	dev-libs/opensc
	app-crypt/ccid
	sys-apps/lsb-release
	sys-apps/pcsc-tools
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
		apache-modssl
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
	mkdir -p usr/lib
	mv etc/udev usr/lib/udev

	# alt-compat
	# rm lib64/ld-lsb-x86-64.so.3
	rm etc/init.d/cprocsp

	touch etc/debian_version
	echo "jessie/sid" > etc/debian_version

	cp etc/opt/cprocsp/config64.ini{,.backup}

	ln -s librdrjacarta.so.5.0.0 opt/cprocsp/lib/amd64/librdrjacarta.so.1.0

	rm opt/cprocsp/sbin/amd64/oauth_gtk2
}

src_install() {
	local arch=$(_get_arch)

	insinto /
	doins -r opt etc usr var

	exeinto /opt/cprocsp/bin/"${arch}"
	doexe opt/cprocsp/bin/"${arch}"/*
	exeinto /opt/cprocsp/sbin/"${arch}"
	doexe opt/cprocsp/sbin/"${arch}"/*
	exeinto /opt/cprocsp/lib/"${arch}"
	doexe opt/cprocsp/lib/${arch}/*

	exeinto /etc/opt/cprocsp
	doexe ${FILESDIR}/cprocsp_postinstal_all_scripts.sh

	keepdir /var/opt/cprocsp/dsrf
	keepdir /var/opt/cprocsp/dsrf/db1
	keepdir /var/opt/cprocsp/dsrf/db2
	keepdir /var/opt/cprocsp/keys
	keepdir /var/opt/cprocsp/tmp
	keepdir /var/opt/cprocsp/users
	keepdir /var/opt/cprocsp/users/stores

	insinto /etc/opt/cprocsp/

	# ini файлы с форума https://forum.calculate-linux.org/t/csp-v-4-5/9989/246
	doins ${FILESDIR}/config64-kc1.ini
	doins ${FILESDIR}/config64-kc2.ini
	doins ${FILESDIR}/config64-donnstro.ini
	doins ${FILESDIR}/config64-5.0.12000.ini
	doins ${FILESDIR}/goodconfig64.ini

	newinitd ${FILESDIR}/cprocsp-5.0.12000 cprocsp
	# TODO: make it just script, and make normal openrc init-file
	# TODO: systemd unit

	newenvd - "99${PN}" <<-_EOF_
		PATH=/opt/cprocsp/bin/${arch}:/opt/cprocsp/sbin/${arch}
	_EOF_
}

pkg_postinst() {
	# TODO: think about better permissions
	chmod 1777 /var/opt/cprocsp/keys
	chmod 1777 /var/opt/cprocsp/users
	chmod 1777 /var/opt/cprocsp/tmp

	ebegin "Running postinstall script (pre-configuring)"
	bash /etc/opt/cprocsp/cprocsp_postinstal_all_scripts.sh &>/dev/null
	eend $?
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd xdg udev

DESCRIPTION="CryptoPro Crypto Provider"

SRC_URI="
	x86? ( ${P}_x86.tgz )
	amd64? ( ${P}_amd64.tgz )
	arm? ( ${P}_arm.tgz )
	arm64? ( ${P}_arm64.tgz )
"

HOMEPAGE="https://cryptopro.ru/products/csp/downloads"
LICENSE="Crypto-Pro"
RESTRICT="bindist fetch mirror strip"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib
	dev-libs/libusb-compat
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/pam
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/pango
"
RDEPEND="
	app-crypt/ccid
	>=dev-libs/libp11-0.4.0
	dev-libs/libxml2
	x86? ( dev-libs/opensc )
	amd64? ( dev-libs/opensc )
	media-libs/libpng:0
	media-libs/fontconfig
	sys-apps/dbus
	sys-apps/lsb-release
	>=sys-apps/pcsc-lite-1.4.99
	sys-apps/pcsc-tools
	virtual/libcrypt:=
	virtual/libusb:0
	${DEPEND}
"
# media-libs/libcanberra[gtk2]
# x11-misc/appmenu-gtk-module[gtk2]
# ^ Actually, having gtk2 on them doesn't strictly needed.
# It works just fine without it. It might be added just to silence warnings on startup, but gtk2 is deprecated.
# keepeng them in case upstream will go crazy and make them mandatory.

BDEPEND="
	app-arch/rpm2targz
	app-alternatives/bzip2
"

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
	einfo "Then download it, and place at ${PORTAGE_ACTUAL_DISTDIR}/${A}"
	ewarn "Please, post an issue on GitHub in case of checksums mismatch"
}

src_unpack() {
	local uname_m=$(uname -m)
	local arch=$(_get_arch);
	local libdir=$(get_libdir)

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
		cprocsp-pki{,-{plugin,cades}} # ,phpcades}}
	)
	for f in ${PKGS[@]} ${ADD_PKGS[@]}; do
		find "../linux-${arch}" -name "${f}*.rpm" | while read r; do rpm_unpack "./${r}"; done
	done

	mkdir -p usr/lib || die
	mv etc/udev usr/lib/udev || die

	mkdir -p usr/${libdir}/readers/usb || die
	mv usr/${libdir}/pcsc/drivers/* usr/${libdir}/readers/usb/ || die

	mv opt/cprocsp/share/* usr/share/ || die
	rmdir opt/cprocsp/share || die

	mkdir -p usr/lib/mozilla/plugins || die
	cp -lL opt/cprocsp/lib/${arch}/libnpcades.so usr/lib/mozilla/plugins/ || die

	# cp etc/opt/cprocsp/config64.ini{,.backup} || die # What about non-64bit installs?
	bzip2 -d -c < "${FILESDIR}"/cprocsp_postinstal_all_scripts.sh.bz2 > "${T}"/postinst.bash || die
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

	keepdir /var/opt/cprocsp/dsrf
	keepdir /var/opt/cprocsp/dsrf/db1
	keepdir /var/opt/cprocsp/dsrf/db2
	keepdir /var/opt/cprocsp/keys
	keepdir /var/opt/cprocsp/tmp
	keepdir /var/opt/cprocsp/users
	keepdir /var/opt/cprocsp/users/stores
	keepdir /var/opt/cprocsp/mnt

	# insinto /etc/opt/cprocsp

	# alt-compat
	# rm "${arch}"/ld-lsb-x86-64.so.3
	# rm etc/init.d/cprocsp
	mv etc/init.d/cprocsp opt/cprocsp/cprocsp.init || die # FIXME:

	newinitd "${FILESDIR}/${P}" cprocsp
	# TODO: ^ make it just script, and make normal openrc init-file
	systemd_dounit "${FILESDIR}/${PN}.service"

	newenvd - "99${PN}" <<-_EOF_
		PATH=/opt/cprocsp/bin/${arch}:/opt/cprocsp/sbin/${arch}
	_EOF_
}

pkg_postinst() {
	local arch=$(_get_arch)
	local pi_st

	/etc/init.d/cprocsp repair_var

	ebegin "Running postinstall script (pre-configuring)"
		bash "${T}"/postinst.bash &>"${T}/postinst.log"
		pi_st=$?
	eend "${pi_st}"
	if [[ "${pi_st}" -gt 0 ]]; then
		eerror "Something gone wrong during postinstall. It is not necessarily bad, but check the log just in case:"
		eerror "=================="
		cat "${T}/postinst.log"
		eerror "=================="
	fi

	xdg_desktop_database_update
	udev_reload

	einfo "You may want to run following command as user (not root):"
	einfo "    /opt/cprocsp/bin/"${arch}"/csptestf -absorb -certs -autoprov"
	einfo "to import cryptocontainers and certificates from USB-smartcard (aka token)"
}

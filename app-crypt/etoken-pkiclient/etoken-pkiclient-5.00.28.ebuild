# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils 

DESCRIPTION="Aladdin eToken Middleware for eTokenPRO, eTokenNG OTP, eTokenNG Flash, eToken Pro (Java)"
HOMEPAGE="http://www.etokenonlinux.org"
MY_PY="pkiclient-5.00.28-0.x86_64"
MY_P="$MY_PY.rpm"
PATHNAME="etoken-gentoo-5.00.28.diff"
SRC_URI="${MY_P}"

LICENSE="Aladdin Knowledge Systems"
RESTRICT="nomirror"
SLOT="0"
KEYWORDS="-* amd64"

#IUSE="gnome"
DEPEND="app-arch/rpm2targz"
RDEPEND=">=sys-apps/pcsc-lite-1.4.99
dev-libs/libusb
media-libs/fontconfig"
#dev-libs/engine_pkcs11
#">=x11-libs/qt-core-4.2.3"

RESTRICT="fetch"

S="${WORKDIR}"

pkg_nofetch() {
    einfo "Please send mail to cornelius.koelbel@lsexperts.de with request"
    einfo "to provide a 5.00.28 version driver for eToken and put it into"
    einfo "${DISTDIR} as ${MY_P}"
}

src_unpack() {
	cp "${DISTDIR}"/"${MY_P}" "${WORKDIR}"
	rpm2targz ${MY_P}
	unpack ./${MY_PY}.tar.gz
	epatch "${FILESDIR}"/${PATHNAME}
}

src_install() {
	insinto /
	doins -r var
	
	cd etc
	####################patch
	newinitd init.d/eTSrv eTSrv
	insinto /etc/env.d
	newins ld.so.conf.d/wwwwetoken-ld.conf 99etoken
	insinto /etc
	doins eToken*.conf


	cd ../lib
	
	exeinto /lib32
	for i in *.5.00; do
	    doexe $i
	    dosym $i /lib32/${i/\.5.00/}
	done
	
	cd ../lib64
	exeinto /lib64
	for i in *.5.00; do
	    doexe $i
	    dosym $i /lib64/${i/\.5.00/}
	done
	
	cd ../usr
	into /usr
	dobin bin/*
	cd share
	insinto /usr/share
	doins -r doc
	cd eToken
	insinto /usr/share/eToken
	doins -r languages
	#make_desktop_entry
	doins -r shortcuts
	doins -r LogoImages
	########## doicon?
	cd drivers/aks-ifdh.bundle/Contents/
	insinto /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/
	doins Info.plist
	cd Linux
	exeinto /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux
##	into /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux ##
	insinto /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux
	doins readme.txt
	doexe libAksIfdh.so.5.00
	dosym libAksIfdh.so.5.00 /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so
##	dolib.so libAksIfdh.so.4.55 ##
#	dosym libAksIfdh.so.4.55 /usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so
#	mkdir -p ${WORKDIR}/usr/lib32/readers/usb/
	dosym /usr/share/eToken/drivers/aks-ifdh.bundle /usr/lib/readers/usb/aks-ifdh.bundle
	
	cd ${WORKDIR}/usr/lib
	insinto /usr/lib
        dosym ../../lib32/libeToken.so.5.00 /usr/lib32/libeTFS.so
        dosym ../../lib32/libeToken.so.5.00 /usr/lib32/libeTPkcs11.so
        dosym ../../lib32/libeToken.so.5.00 /usr/lib32/libeTSapi.so
        dosym ../../lib32/libeToken.so.5.00 /usr/lib32/libeToken.so
	dosym ../../lib32/libeTokenUI.so.5.00 /usr/lib32/libeTokenUI.so

	cd eToken
	insinto /usr/lib32/eToken
	into /usr/lib32/eToken/
	dobin bin/*
	exeinto /usr/lib32/eToken/nss_tools
	doexe nss_tools/*
	exeinto /usr/lib32/eToken/plugins/imageformats
	doexe plugins/imageformats/*
	exeinto /usr/lib32/eToken/
	for i in *.4.2.3; do
	    doexe $i;
	    dosym $i /usr/lib32/eToken/${i/\.2\.3/};
	done
	for i in *.so; do
	    doexe $i;
	done
}

pkg_postinst() {
	einfo "Run"
	einfo "rc-update add eTSrv default"
	einfo "to add eToken support to default runlevel"
	einfo ""
	einfo "In some cases the eToken will not work after rebooting your system. This can be due to the fact, that your pcscd is not running. The installation of pki-client does not configure the pcscd to start automatically."
}

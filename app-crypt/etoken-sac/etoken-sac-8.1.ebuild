# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: mva $

EAPI="4"

inherit eutils rpm

DESCRIPTION="SafeNet (Aladdin) eToken Middleware for eTokenPRO, eTokenNG OTP, eTokenNG Flash, eToken Pro (Java)"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV}.0-4"
MY_P_86="${MY_PN}-${MY_PV}.i386.rpm"
MY_P_64="${MY_PN}-${MY_PV}.x86_64.rpm"
MY_COMPAT_P="SAC-32-CompatibilityPack-${MY_PV}.x86_64.rpm"

SRC_URI="x86? ( ${MY_P_86} )
	amd64? ( ${MY_P_64} ${MY_COMPAT_P} )"

HOMEPAGE="http://www.etokenonlinux.org"
LICENSE="Aladdin Knowledge Systems"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="ssl"

RDEPEND=">=sys-apps/pcsc-lite-1.4.99
	dev-libs/libusb
	media-libs/fontconfig
	ssl? ( dev-libs/engine_pkcs11 )"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please send mail to Aladdin eToken TS <support.etoken@aladdin-rd.ru> and"
	einfo "ask them to provide a ${PV} version of eToken driver. Then put RPMs from"
	einfo "archive, they emailed to you, into ${DISTDIR} ( cp ${A} ${DISTDIR} )"
}

src_unpack() {
	cd "${S}"
	rpm_src_unpack ${A}

	use x86 && ( cat "${FILESDIR}/libhal_32.txz" | tar xJf - )
	use amd64 && ( cat "${FILESDIR}/libhal_64.txz" | tar xJf - )
	use amd64 && ( cat "${FILESDIR}/pcsc_64.txz" | tar xJf - )

	cp "${FILESDIR}/eTSrv.init-r1" etc/init.d/eTSrv
	cp "${FILESDIR}/Makefile" "${S}"
}

src_prepare() {
	default
	EPATCH_SOURCE="${FILESDIR}/patches" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch

	epatch_user
}

pkg_postinst() {
	einfo "Run"
	einfo "rc-update add eTSrv default"
	einfo "to add eToken support to default runlevel"
	einfo ""
	einfo "In some cases the eToken will not work after rebooting your system. This can be due to the fact, that your pcscd is not running. The installation of pki-client does not configure the pcscd to start automatically."
}

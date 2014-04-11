# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

inherit eutils multilib rpm

DESCRIPTION="SafeNet (Aladdin) eToken Middleware for eTokenPRO, eTokenNG OTP, eTokenNG Flash, eToken Pro (Java)"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV/_p/-}"
MY_P_86="${MY_PN}-${MY_PV}.i386.rpm"
MY_P_64="${MY_PN}-${MY_PV}.x86_64.rpm"
MY_COMPAT_P="SAC-32-CompatibilityPack-${MY_PV}.x86_64.rpm"

SRC_URI="x86? ( ${MY_P_86} )
	amd64? ( ${MY_P_64} ${MY_COMPAT_P} )"

HOMEPAGE="http://www.etokenonlinux.org"
LICENSE="EULA"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="ssl multilib"

REQUIRED_USE="amd64? ( multilib )"

# TODO: minimal useflag (I can't do it now, since
# it seems like I brake my token and it is uninitialized now)
RDEPEND="
	>=sys-apps/pcsc-lite-1.4.99
	|| (
		dev-libs/libusb-compat
		dev-libs/libusb:0
	)
	sys-apps/dbus
	media-libs/libpng:1.2
	media-libs/fontconfig
	ssl? ( dev-libs/engine_pkcs11 )
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please send mail to Aladdin eToken TS <support.etoken@aladdin-rd.ru> and"
	einfo "ask them to provide a ${MY_PV} version of eToken driver. Then put RPMs from"
	einfo "archive, they emailed to you, into ${DISTDIR} ( cp ${A} ${DISTDIR} )"
	echo
	einfo "Actually, you can ask them for most actual version, and if they send you"
	einfo "version, newer then ${MY_PV}, then report it to the bugtracker, please"

}

src_unpack() {
	cd "${S}"
	rpm_src_unpack ${A}

	use x86 && ( cat "${FILESDIR}/dist/libhal_x86.txz" | tar xJf - )
	use amd64 && ( cat "${FILESDIR}/dist/libhal_amd64_lib32.txz" | tar xJf - )
	use amd64 && ( cat "${FILESDIR}/dist/libhal_amd64_lib64.txz" | tar xJf - )
	use amd64 && ( cat "${FILESDIR}/dist/pcsc_amd64.txz" | tar xJf - )
}

src_prepare() {
	default
	EPATCH_SOURCE="${FILESDIR}/patches" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch

	epatch_user

	cp "${FILESDIR}/eTSrv.init-r3" etc/init.d/eTSrv
	cp "${FILESDIR}/dist/Makefile" "${S}"
}

pkg_postinst() {
	ewarn "!!!!!!!"
	ewarn "Currently, Gentoo Dev Team has removed libusb:0 from the portage tree"
	ewarn "(although, it is still in multilib overlay)"
	ewarn "For now, I added libusb-compat (wrapper) as a dependency,"
	ewarn "but it can either work or doesn't work for you."
	echo
	ewarn "If it'll not — try to emerge libusb:0 from multilib overlay."
	ewarn "!!!!!!!"
	echo
	einfo "Run"
	einfo "rc-update add pcscd default"
	einfo "rc-update add eTSrv default"
	einfo "to add eToken support daemon to autostart"
	einfo ""
	einfo "In some cases the eToken will not work after rebooting your system."
	einfo "This can be due to the fact, that your pcscd is not running."
	einfo "This may happen if you forgot to add pcscd to default runlevel"
	einfo "(or because of crash)."
	echo
	einfo "If you need some help, you can ask the help in that article:"
	einfo "http://www.it-lines.ru/blogs/linux/nastrojka-etoken-v-gentoo-linux"
}

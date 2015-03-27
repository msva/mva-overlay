# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

inherit eutils multilib rpm

DESCRIPTION="SafeNet (Aladdin) eToken Middleware for eTokenPRO, eTokenNG OTP, eTokenNG Flash, eToken Pro (Java)"

MAGIC_DATE="10.12.2013"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV/_p/-}"

MY_P_CORE="Core/RPM/${MY_PN}-core-${MY_PV}"
MY_P_STD="Standard/RPM/${MY_PN}-${MY_PV}"
MY_P_COMPAT="x32 Compatibility/RPM/SAC-32-CompatibilityPack-${MY_PV}"

SRC_URI="http://online.payment.ru/drivers/SAC_${PV%.*}_Linux_${MAGIC_DATE}.zip"

HOMEPAGE="http://aladdin-rd.ru"
LICENSE="EULA"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="ssl multilib minimal"

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

#pkg_nofetch() {
#	einfo "Please send mail to Aladdin eToken TS <support.etoken@aladdin-rd.ru> and"
#	einfo "ask them to provide a ${MY_PV} version of eToken driver. Then put RPMs from"
#	einfo "archive, they emailed to you, into ${DISTDIR} ( cp ${A} ${DISTDIR} )"
#	echo
#	einfo "Actually, you can ask them for most actual version, and if they send you"
#	einfo "version, newer then ${MY_PV}, then report it to the bugtracker, please"
#
#}

src_unpack() {
	local arch=x86;
	use amd64 && arch=x86_64;
	default;
	cd "${S}"
	if use minimal; then
		rpm_unpack "./Installation/${MY_P_CORE}.${arch}.rpm";
	else
		rpm_unpack "./Installation/${MY_P_STD}.${arch}.rpm";
	fi
	use amd64 && (
		rpm_unpack "./Installation/${MY_P_COMPAT}.${arch}.rpm";
	)
}

src_prepare() {
	default
	EPATCH_SOURCE="${FILESDIR}/patches" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch

	epatch_user

	cp "${FILESDIR}/SACSrv.init" etc/init.d/SACSrv
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
	einfo "rc-update add SACSrv default"
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

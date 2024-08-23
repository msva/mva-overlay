# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="SafeNet (Aladdin) eTokens Middleware (PRO, NG OTP, Flash, Java)"
HOMEPAGE="https://aladdin-rd.ru"

#MAGIC_DATE="10.12.2013"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV/_p/-}"

MY_P_CORE="Core/RPM/${MY_PN}-core-${MY_PV}"
MY_P_STD="Standard/RPM/${MY_PN}-${MY_PV}"
MY_P_COMPAT="x32 Compatibility/RPM/SAC-32-CompatibilityPack-${MY_PV}"

SRC_PV=${PV%.*}
SRC_PV=${SRC_PV/./_}

SRC_URI="https://online.payment.ru/drivers/SAC_${SRC_PV}_Linux.zip"

S="${WORKDIR}/SAC_${SRC_PV}_Linux"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl multilib minimal"
RESTRICT="mirror"

# TODO:
# - minimal useflag (I can't do it now, since
#   it seems like I brake my token and it is uninitialized now)
# - systemd unit
# - replace buildsystem
# - move libraries (.so) in proper places under /usr

RDEPEND="
	>=sys-apps/pcsc-lite-1.4.99
	virtual/libusb:0
	sys-apps/dbus
	media-libs/libpng:0
	media-libs/fontconfig
	ssl? ( >=dev-libs/libp11-0.4.0 )
	media-libs/hal-flash
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"
QA_MULTILIB_PATHS="usr/lib32/.* usr/lib64/.* lib32/.* lib64/.*"

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
	local arch=i386;
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

#PATCHES="${FILESDIR}/patches/*.patch"

src_prepare() {
#	eapply "${FILESDIR}"/patches/*.patch

	default
	cp "${FILESDIR}/SACSrv.init" etc/init.d/SACSrv
	cp "${FILESDIR}/dist/Makefile" "${S}"
}

pkg_postinst() {
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

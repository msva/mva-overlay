# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker patches

DESCRIPTION="Crypto-provider browser plugin for russian e-gov site https://gosuslugi.ru/"

SRC_URI="
	amd64? ( ${P}_amd64.deb )
	x86? ( ${P}_x86.deb )
"

HOMEPAGE="https://gosuslugi.ru/"
LICENSE="all-rights-reserved"
RESTRICT="mirror strip"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libxml2:2
	sys-apps/pcsc-lite:0
	virtual/libusb:0
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"

S="${WORKDIR}"

pkg_nofetch() {
	local BASE_URI="https://ds-plugin.gosuslugi.ru/plugin/upload/"
	local pkg
	if use amd64; then
		pkg="IFCPlugin-x86_64.deb"
	elif use x86; then
		pkg="IFCPlugin-i386.deb"
	else
		die "Unsupported architecture!"
	fi
	eerror "Distribution file for plugin not found!"
	eerror "Please, dowload file named ${pkg} from ${BASE_URI}"
	eerror "and place it as ${PORTAGE_ACTUAL_DISTDIR}/${A}"
}

src_unpack() {
	unpack_deb ${A}
	rm usr/lib/mozilla/plugins/lib/libcapi_engine_linux.so
}

src_install() {
	insinto /
	doins -r usr etc opt
	dobin usr/bin/ifc_chrome_host
	keepdir /var/log/ifc
	fperms 1777 /var/log/ifc

	insinto /etc/chromium/native-messaging-hosts
	doins etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json
}

#pkg_postinst() {
#	cd /etc/update_ccid_boundle
#	sh ./update_ccid_boundle.sh
#}

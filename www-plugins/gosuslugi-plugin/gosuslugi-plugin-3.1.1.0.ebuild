# Copyright 1999-2024 Gentoo Authors
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
RESTRICT="fetch mirror strip"
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

	eerror "Please, open ${BASE_URI}, download file named ${pkg} (downloading may start automatically)"
	eerror "and copy/move/symlink it to ${PORTAGE_ACTUAL_DISTDIR}/${A}"
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local cfg
	if use amd64; then
		cfg="ifcx64.cfg"
	elif use x86; then
		cfg="ifcx86.cfg"
	else
		die "Unsupported architecture!"
	fi

	rm usr/lib/mozilla/plugins/lib/libcapi_engine_linux.so || die # linked against missing libs
	rm -r etc/update_ccid_boundle || die # unnneeded crap
	rm etc/ifc.cfg || die # broken encoding, missing cprocsp pkcs11 driver

	insinto /etc
	newins "${FILESDIR}/${cfg}" ifc.cfg

	insinto /
	doins -r usr etc opt
	dobin usr/bin/ifc_chrome_host

	keepdir /var/log/ifc/engine_logs

	insinto /etc/chromium/native-messaging-hosts
	doins etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json
}

pkg_postinst() {
	# otherwise it tries to create it as user, with 777 on path
	local log="/var/log/ifc/engine_logs/engine.log"
	touch "${log}"
	fperms 666 "${log}" # plugin doesn't work otherwise
	# (all users who run it should be able to write in it, or plugin crashes)
	# TODO: think about proper fix before moving to gentoo repo.
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker patches

DESCRIPTION="Crypto-provider browser plugin for russian e-gov site https://gosuslugi.ru/"
HOMEPAGE="https://gosuslugi.ru/"

BASE_URI="https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib"
SRC_URI="
	amd64? ( ${BASE_URI}/IFCPlugin-x86_64.deb -> ${P}_amd64.deb )
	x86? ( ${BASE_URI}/IFCPlugin-i386.deb -> ${P}_x86.deb )
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"

RDEPEND="
	dev-libs/libxml2:2
	sys-apps/pcsc-lite:0
	virtual/libusb:0
"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"
QA_SONAME_NO_SYMLINK="usr/lib32/.* usr/lib64/.*"

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
		ewarn "Upstream is hostile, and have no versioned distfiles"
		ewarn "So, you should expect random checksum verification errors sometimes"
		ewarn "In cases when it happens - place an issue on overlay's issue tracker on GitHub, please"
	fi
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
	chmod 666 "${log}" # plugin doesn't work otherwise
	# (all users who run it should be able to write in it, or plugin crashes)
	# TODO: think about proper fix before moving to gentoo repo.
}

# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit unpacker patches

DESCRIPTION="Crypto-provider browser plugin for russian e-gov site https://gosuslugi.ru/"
HOMEPAGE="https://gosuslugi.ru/"

SRC_URI="https://gu-st.ru/content/Gosplugin/Gosplugin_Linux-Debian_Installer.deb.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="
	dev-libs/libxml2:2
	sys-apps/pcsc-lite:0
	virtual/libusb:0
"
# TODO: 👆
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
	unpack_zip "${A}"
	local installer="${WORKDIR}/${A/zip/sh}"
	local offset=$(($(grep --text --line-number '^PAYLOAD:$' ${installer} | cut -d: -f1)+1))
	tail -n "+${offset}" "${installer}" | tar -x || die "Failed to unpack deb from installer"
	unpack_deb *${PV}*.deb
	rm *deb* || die "Failed to remove remaining crap"
}

src_prepare() {
	default
	sed '$iunset XDG_SESSION_TYPE\n' -i opt/iitrust/gosuslugi_plugin/bin/gosuslugi_plugin.sh || die
	# NOTE: 👆 looks like bundled Qt5 doesn't support Wayland...
}

src_install() {
	insinto /
	doins -r usr etc opt
	fperms +x opt/iitrust/gosuslugi_plugin/bin/{gosuslugi_plugin{,.sh},openurl,xdg-open.sh}
}

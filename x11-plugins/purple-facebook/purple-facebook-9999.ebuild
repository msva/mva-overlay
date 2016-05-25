# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils mercurial git-r3

DESCRIPTION="Whatsapp plugin for libpurple (Pidgin)"
HOMEPAGE="https://github.com/jgeboski/purple-facebook"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

EGIT_REPO_URI="https://github.com/jgeboski/purple-facebook"

DEPEND="
	net-im/pidgin
	dev-libs/json-glib
	dev-libs/glib:2
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	EHG_REPO_URI="https://bitbucket.org/pidgin/main" \
	EHG_PROJECT="pidgin" \
	EHG_CHECKOUT_DIR="${S}/.pidgin" \
	EHG_REVISION=$(cat ${S}/VERSION) \
	mercurial_src_unpack
}

src_prepare() {
	touch $(cat MANIFEST_VOIDS)

	sed -i \
		-e '/^PLUGIN_CFLAGS/s@`pwd`/@@g' \
		configure.ac

	for f in $(cat MANIFEST_PIDGIN); do
		mkdir -p $(dirname "pidgin/${f}")
		cp ".pidgin/${f}" "pidgin/${f}"
	done

	EPATCH_OPTS="-d ${S}/pidgin"
	epatch "${S}"/patches/*.patch

	autotools-utils_src_prepare
}

src_install() {
	prune_libtool_files
	autotools-utils_src_install
}

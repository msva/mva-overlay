# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3
#mercurial

DESCRIPTION="Facebook plugin for libpurple (Pidgin)"
HOMEPAGE="https://github.com/jgeboski/purple-facebook"

LICENSE="GPL-2"
SLOT="0"

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
	# EHG_REPO_URI="https://bitbucket.org/pidgin/main" \
	# EHG_PROJECT="pidgin" \
	# EHG_CHECKOUT_DIR="${S}/.pidgin" \
	# EHG_REVISION=$(cat ${S}/VERSION) \
	# mercurial_src_unpack
}

src_prepare() {
	touch $(cat MANIFEST_VOIDS)

	for f in $(cat MANIFEST_PIDGIN); do
		mkdir -p $(dirname "pidgin/${f}")
		cp ".pidgin/${f}" "pidgin/${f}" &>/dev/null
	done

	eapply -d "${S}/pidgin" -- "${S}"/patches/*.patch

	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

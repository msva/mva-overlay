# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3
EGIT_REPO_URI="https://github.com/lukas2511/letsencrypt.sh"
KEYWORDS=""

DESCRIPTION="letsencrypt/acme client implemented as a shell-script"
HOMEPAGE="https://github.com/lukas2511/letsencrypt.sh"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	sys-apps/coreutils
	net-misc/curl
	dev-libs/openssl
"

DEPEND=""

DOCS=( README.md docs/. )

src_install() {
	dobin letsencrypt.sh
	docompress -x /usr/share/doc/${PF}/examples
	default
}

src_test() {
	./test.sh
}

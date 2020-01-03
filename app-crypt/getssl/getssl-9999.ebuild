# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3
EGIT_REPO_URI="https://github.com/srvrco/getssl"
KEYWORDS=""

DESCRIPTION="letsencrypt/acme client implemented as a shell-script"
HOMEPAGE="https://github.com/srvrco/getssl"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	net-dns/bind-tools
	sys-apps/grep
	virtual/awk
	sys-apps/sed
	net-misc/openssh
	sys-apps/coreutils
	net-misc/curl
	dev-libs/openssl
"
DEPEND=""

DOCS=( README.md )

src_compile() { :; }

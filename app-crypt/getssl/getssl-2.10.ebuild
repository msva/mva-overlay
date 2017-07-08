# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/srvrco/getssl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/srvrco/getssl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

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

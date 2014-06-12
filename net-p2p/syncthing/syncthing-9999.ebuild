# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; Bumped by mva; $

EAPI="5"

inherit eutils

if [ "$PV" != "9999" ]; then
	SRC_URI="https://github.com/calmh/${PN}/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm ~darwin ~winnt ~fbsd"
else
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/calmh/${PN}"
	KEYWORDS=""
fi

DESCRIPTION="Open, trustworthy and decentralized syncing engine (like DropBox and BTSync)"
HOMEPAGE="http://syncthing.net"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/go"
RDEPEND="${DEPEND}"

die "Gentoo currently does not provide a way to install go extensions. So, if you have an idea how to bundle GoDep and vet — welcome to contribute."

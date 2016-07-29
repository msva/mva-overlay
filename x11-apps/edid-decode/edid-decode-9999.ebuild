# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/app/edid-decode"

DESCRIPTION="Edid decoder"
HOMEPAGE="http://cgit.freedesktop.org/xorg/app/edid-decode"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/libc"

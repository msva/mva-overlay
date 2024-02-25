# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/app/edid-decode"

DESCRIPTION="Edid decoder"
HOMEPAGE="https://cgit.freedesktop.org/xorg/app/edid-decode"

LICENSE="LGPL-3"
SLOT="0"

DEPEND="virtual/libc"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Tool to guess CPU_FLAGS flags for the host"
HOMEPAGE="https://github.com/mgorny/cpuid2cpuflags"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/cpuid2cpuflags"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

src_prepare() {
	default
	eautoreconf
}

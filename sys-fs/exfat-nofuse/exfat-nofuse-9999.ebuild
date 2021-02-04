# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 linux-mod

DESCRIPTION="Non-fuse kernel driver for exFat and VFat file systems"
HOMEPAGE="https://github.com/dorimanx/exfat-nofuse"
EGIT_REPO_URI="git://github.com/dorimanx/exfat-nofuse.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

MODULE_NAMES="exfat(kernel/fs:${S})"
BUILD_TARGETS="all"

src_prepare(){
	sed -i -e "/^KREL/d" Makefile || die
	default
}

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}

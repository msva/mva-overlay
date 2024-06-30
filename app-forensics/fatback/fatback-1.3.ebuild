# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to undelete files from FAT file systems"
HOMEPAGE="https://fatback.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	dobin ${PN}
	doman ${PN}.1
}

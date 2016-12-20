# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit git-r3 distutils-r1

DESCRIPTION="A tool for identifying files embedded inside firmware images"
HOMEPAGE="https://github.com/devttys0/binwalk"
SRC_URI="" # https://github.com/devttys0/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="https://github.com/devttys0/binwalk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="graph"

RDEPEND="
	sys-fs/mtd-utils
	app-arch/gzip
	app-arch/bzip2
	app-arch/tar
	app-arch/arj
	app-arch/p7zip
	app-arch/cabextract
	sys-fs/squashfs-tools
	app-crypt/ssdeep
	sys-apps/file[${PYTHON_USEDEP}]
	graph? ( dev-python/pyqtgraph[opengl,${PYTHON_USEDEP}] )
"
# lhasa cramfsprogs cramfsswap

python_install_all() {
	local DOCS=( API.md INSTALL.md )
	distutils-r1_python_install_all
}

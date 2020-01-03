# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit git-r3 distutils-r1

DESCRIPTION="JFFS2 filesystem extraction tool"
HOMEPAGE="https://github.com/sviehb/jefferson"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sviehb/jefferson"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/cstruct"
RDEPEND="${DEPEND}"

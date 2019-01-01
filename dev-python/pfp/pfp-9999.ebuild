# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit git-r3 distutils-r1

DESCRIPTION="010 Template interpretter for python"
HOMEPAGE="https://github.com/d0c-s4vage/pfp"
EGIT_REPO_URI="https://github.com/d0c-s4vage/${PN}"
#/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/six
	dev-python/intervaltree
	>=dev-python/py010parser-0.1.5
"
RDEPEND="${DEPEND}"

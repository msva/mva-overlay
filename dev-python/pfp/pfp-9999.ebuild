# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

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

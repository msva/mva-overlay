# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit git-r3 distutils-r1

DESCRIPTION="010 template library for python"
HOMEPAGE="https://github.com/d0c-s4vage/py010parser/"
EGIT_REPO_URI="https://github.com/d0c-s4vage/${PN}"
#/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

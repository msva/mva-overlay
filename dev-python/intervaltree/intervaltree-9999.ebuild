# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit git-r3 distutils-r1

DESCRIPTION="Editable interval tree data structure for Python 2 and 3"
HOMEPAGE="https://github.com/chaimleib/intervaltree"
EGIT_REPO_URI="https://github.com/chaimleib/${PN}"
#/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/sortedcontainers"
RDEPEND="${DEPEND}"

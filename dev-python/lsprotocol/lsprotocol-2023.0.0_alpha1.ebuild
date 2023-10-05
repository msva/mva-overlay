# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1 pypi

DESCRIPTION="Python implementation of the Language Server Protocol"
HOMEPAGE="https://pypi.org/project/lsprotocol/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

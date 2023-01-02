# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

DISTUTILS_USE_PEP517="setuptools"

inherit git-r3 distutils-r1

DESCRIPTION="JFFS2 filesystem extraction tool"
HOMEPAGE="https://github.com/sviehb/jefferson"
EGIT_REPO_URI="https://github.com/sviehb/jefferson"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-python/python-cstruct"
RDEPEND="${DEPEND}"

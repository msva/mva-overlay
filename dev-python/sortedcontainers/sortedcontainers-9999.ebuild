# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..14} python3_13t )

inherit git-r3 distutils-r1

MY_PN="python-sortedcontainers"

DESCRIPTION="Python Sorted Container Types: SortedList, SortedDict, and SortedSet"
HOMEPAGE="https://github.com/grantjenks/python-sortedcontainers"
EGIT_REPO_URI="https://github.com/grantjenks/${MY_PN}"

LICENSE="Apache-2.0"
SLOT="0"

RESTRICT="test"

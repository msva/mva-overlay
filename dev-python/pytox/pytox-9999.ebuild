# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..12} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aitjcize/PyTox.git"
else
	SRC_URI="https://github.com/aitjcize/PyTox/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for the Tox library"
HOMEPAGE="https://github.com/aitjcize/PyTox"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="net-libs/tox"
DEPEND="${RDEPEND}"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 eutils

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

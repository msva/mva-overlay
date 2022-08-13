# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Implementation of the olm and megolm cryptographic ratchets"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"

inherit cmake-multilib

if [[ ${PV} != "9999" ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://gitlab.matrix.org/matrix-org/${PN}/-/archive/${PV}/${P}.tar.bz2"
else
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.matrix.org/matrix-org/${PN}.git"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

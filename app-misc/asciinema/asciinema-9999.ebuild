# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..14} python3_13t )

inherit distutils-r1

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="https://asciinema.org/ https://pypi.org/project/asciinema/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
	EGIT_BRANCH="main"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

PATCHES=(
	"${FILESDIR}/asciinema-2.2.0-setup.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e "s|share/doc/asciinema|&-${PVR}|" setup.cfg || die
}

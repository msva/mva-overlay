# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 git-r3

DESCRIPTION="Command line recorder for asciinema.org service"
HOMEPAGE="https://asciinema.org/ https://pypi.org/project/asciinema/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}"

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

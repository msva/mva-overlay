# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-r1 git-r3

DESCRIPTION="A tool measure distances on the screen "
HOMEPAGE="https://github.com/FRiMN/Rackman"
SRC_URI=""
EGIT_REPO_URI="https://github.com/FRiMN/Rackman"

IUSE=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pygtk:2"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	doicon rackman.svg
	domenu rackman.desktop

	python_foreach_impl python_newscript rackman.py rackman
	distutils-r1_python_install_all
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Generate Your Projects"
HOMEPAGE="https://gyp.gsrc.io/"
EGIT_REPO_URI="https://chromium.googlesource.com/external/${PN}"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
else
	MY_TS="${PV##*_p}"
	EGIT_COMMIT_DATE="${MY_TS:0:4}-${MY_TS:4:2}-${MY_TS:6:2}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

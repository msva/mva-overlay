# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..12} pypy3 )

inherit python-r1 git-r3

DESCRIPTION="A tool displaying unicode character properties"
HOMEPAGE="https://github.com/garabik/unicode"
EGIT_REPO_URI="https://github.com/garabik/${PN}"
#/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

DEPEND="
	app-i18n/unicode-data
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=(README{,-paracode})

src_install() {
	dobin {uni,para}code
	doman {uni,para}code.1

	default
	python_replicate_script "${ED}"/usr/bin/{uni,para}code
}

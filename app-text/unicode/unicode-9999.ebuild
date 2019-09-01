# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} pypy3 )

inherit python-r1 git-r3

DESCRIPTION="A tool displaying unicode character properties"
HOMEPAGE="https://github.com/garabik/unicode"
EGIT_REPO_URI="https://github.com/garabik/${PN}"
#/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+unihan"

DEPEND="
	app-i18n/unicode-data
"
RDEPEND="${DEPEND}"

DOCS=(README{,-paracode})

src_install() {
	dobin {uni,para}code
	doman {uni,para}code.1

	# ⇓⇓⇓ Bikeshedding time! ⇓⇓⇓
	if use unihan && [[ ! -f /usr/share/unicode-data/Unihan.txt ]]; then
		mkdir "${T}"/unihan; cd "${T}"/unihan;
		unzip -q /usr/share/unicode-data/Unihan.zip;
		insinto /usr/share/unicode-data;
		doins Unihan*.txt;
		cd "${S}"
	fi
	default
	python_replicate_script "${ED}"usr/bin/{uni,para}code
}

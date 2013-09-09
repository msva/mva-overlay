# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

inherit git-2

DESCRIPTION="Drush is a command line shell and scripting interface for Drupal"
HOMEPAGE="http://drupal.org/project/drush"
SRC_URI=""

EGIT_REPO_URI="https://github.com/drush-ops/drush"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="dev-lang/php[cli,simplexml] dev-php/pear"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"

src_install() {
	local docs="README.txt docs"

	insinto /usr/share/drush
	doins -r .
	exeinto /usr/share/drush
	doexe drush
	dosym /usr/share/drush/drush /usr/bin/drush
	dodoc -r ${docs}
	# cleanup
	for i in ${docs} LICENSE.txt drush.bat examples includes/.gitignore ; do
		rm -rf "${D}/usr/share/drush/${i}"
	done

	use examples && cp -R examples "${D}"/usr/share/doc/"${PF}"
}

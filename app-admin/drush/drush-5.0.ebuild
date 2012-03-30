# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/drush/drush-4.5.ebuild,v 1.1 2012/03/09 05:03:41 ramereth Exp $

EAPI="4"

DESCRIPTION="Drush is a command line shell and scripting interface for Drupal"
HOMEPAGE="http://drupal.org/project/drush"
SRC_URI="http://ftp.drupal.org/files/projects/${PN}-7.x-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

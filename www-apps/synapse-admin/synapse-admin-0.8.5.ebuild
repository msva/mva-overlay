# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Admin UI for Matrix Synapse homeserver"
HOMEPAGE="https://github.com/Awesome-Technologies/synapse-admin"
SRC_URI="https://github.com/Awesome-Technologies/synapse-admin/releases/download/${PV}/synapse-admin-${PV}.tar.gz"
LICENSE="Apache-2.0"

KEYWORDS="~amd64"

DEPEND="app-admin/webapp-config"

#S=${WORKDIR}/${PN}-${PV}

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}

pkg_postinst() {
#	local mydir="${ROOT%/}/${VHOST_ROOT}/${MY_HTDOCSBASE}/${PN}"
#	if [ ! -e $mydir/config.json ]; then
#		einfo Please copy config.sample.json to config.json
#		einfo in $mydir and tune it to your needs
#	fi
	webapp_pkg_postinst
}

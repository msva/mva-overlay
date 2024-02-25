# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="A minimalist pastebin where the server has zero knowledge of pasted data"
HOMEPAGE="https://privatebin.info/"
SRC_URI="https://github.com/PrivateBin/PrivateBin/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/php[zlib,gd]
"
DEPEND="
	app-admin/webapp-config
"

S=${WORKDIR}/PrivateBin-${PV}

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
	webapp_pkg_postinst
	local mydir="${VHOST_ROOT}/${MY_HTDOCSBASE}/${PN}"
	echo
	if [ ! -e $mydir/cfg/conf.php ]; then
		elog
		elog Please copy conf.sample.php to conf.php
		elog in $mydir/cfg and tune it to your needs
		elog
	else
		elog
		elog See release notes at
		elog https://github.com/PrivateBin/PrivateBin/releases/tag/${PVw}
		elog
		elog And maybe look at diff conf.sample.php conf.php at
		elog $mydir
		elog

	fi
}

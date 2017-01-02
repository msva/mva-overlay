# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module user versionator git-r3

DESCRIPTION="Github clone. you can install Github system into your unix/linux machine."
HOMEPAGE="http://gitprep.yukikimoto.com/"
EGIT_REPO_URI="https://github.com/yuki-kimoto/gitprep"
RESTRICT="test"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-perl/Mojolicious-Plugin-INIConfig
	dev-perl/Mojolicious
	dev-perl/Mojolicious-Plugin-AutoRoute
	dev-perl/Mojolicious-Plugin-BasicAuth
	dev-perl/Mojolicious-Plugin-DBViewer
	dev-perl/DBIx-Connector
	dev-perl/DBIx-Custom
	dev-perl/Text-Markdown-Hoedown
	dev-perl/Data-Page
	virtual/perl-Module-CoreList
	dev-perl/Config-Tiny
	dev-perl/Time-Moment
"
# TODO: fix deplist. It's not full ATM.
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/sh /var/lib/"${PN}" git
}

src_prepare() {
	local sedargs=();
	sedargs+=(-e '/Time/d')
	sedargs+=(-e '/DBD::SQLite/d')
	sedargs+=(-e '/DBI/d')
	sedargs+=(-e '/Object::Simple/d')
	sedargs+=(-e '/Validator::Custom/d')
	sedargs+=(-e '/Config::Tiny/d')
	sedargs+=(-e '/Mojolicious/d')
	sedargs+=(-e '/Data::Page/d')
	sedargs+=(-e '/Markdown/d')

	sed -i "${sedargs[@]}" cpanfile

	sedargs=(-e '/use lib "$FindBin::Bin.*extlib.*perl/d')

	sed -i "${sedargs[@]}" script/{gitprep-shell-raw,import_rep}

	default
}

src_compile() {
	./setup_database
}

src_install() {
	insinto "${VENDOR_LIB}"
	doins -r lib/*

#	insopts -m0755
	exeinto "/usr/libexec/${PN}"
	doexe script/*

	dosym /usr/libexec/"${PN}"/"${PN}" /usr/bin/"${PN}"
	dosym /usr/libexec/"${PN}"/"${PN}"-shell-raw /usr/bin/"${PN}"-shell

	insinto /var/lib/"${PN}"
	doins -r data lock templates tmp "${PN}".conf "${PN}"_image.png public
}

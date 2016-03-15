# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils check-reqs

DESCRIPTION="Linux port of famous RPG-game."
HOMEPAGE="http://www.linuxgamepublishing.com/"

SLOT="0"
LICENSE="EULA"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip test"
IUSE="iampirate linguas_ru"

# Do you really have no $15 to buy sacred on LGP? Okay, you can ask me for
# distfiles, but I recommend you to buy official sacred release from LGP.
SRC_URI="
	sacred.tar.bz2
	iampirate? ( sacred_pirate.tar.bz2 )
	linguas_ru? ( sacred_rus.tar.bz2 )
"

CHECKREQS_DISK_BUILD="2560"
CHECKREQS_MEMORY="256"
S="${WORKDIR}/${PN}"

DEPEND="${RDEPEND}"
RDEPEND="
	x11-base/xorg-server
	>=x11-libs/gtk+-2.0.0
"
# TODO: fix deps

pkg_setup() {
	ewarn ""
	ewarn "If your videodriver don't support OpenGL you"
	ewarn "should not install this game: it will work slowly."
	ewarn ""
	ewarn "Also: Please, be patient: major game archive size is"
	ewarn "about 2GiB! It can unpack for a long time."
	ewarn ""
	# Dirty hack with sed :(
	(check_reqs | sed -e "s/\${T}/your\ system/g") || die "Checking of requirements is failed."
	enewgroup games 35
}

src_install() {
	#TODO: games.eclass (when it will be EAPI4-compatible)
	dodir /opt/${PN}
	cd "${S}"
	chown -R games:games ./*
	cp -R . "${D}"/opt/${PN}
	dodir /usr/games/bin
	dosym /opt/sacred/sacred /usr/games/bin/sacred
	newicon ${S}"/icon.xpm" "${PN}.png"
	make_desktop_entry "${PN}" "Sacred: Gold Edition" "${PN}" "Games"
}

pkg_postinst() {
	elog "Don't forget to add you user in 'games' group."
	elog "Also, don't forget: if you using Graphical Drivers, that don't support"
	elog "OpenGL acceleration, than game will work SLOWLY."
}

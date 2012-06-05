# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

inherit versionator eutils unpacker games

DESCRIPTION="An original action role-playing game set in a lush imaginative world, in which players must create and fight for civilization’s last refuge as a mysterious narrator marks their every move."
HOMEPAGE="http://supergiantgames.com/?page_id=242"

SLOT="0"
LICENSE="EULA"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror fetch strip test"
IUSE=""

SRC_URI="Bastion-HIB-2012-05-29-2.sh"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() {
        unpack_makeself "${A}"
}

src_install() {
        dir=${GAMES_PREFIX_OPT}/${PN}

        insinto "${dir}"
        mv * "${D}/${dir}" || die

        games_make_wrapper ${PN} ./bastion "${dir}" "${dir}"/lib
#        newicon "${CDROM_ROOT}"/.data/icon.xpm ${PN}.xpm || die
        make_desktop_entry ${PN} "Bastion Game" ${PN}

        prepgamesdirs
}

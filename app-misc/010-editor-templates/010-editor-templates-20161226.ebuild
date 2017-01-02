# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="010 Editor Templates"
HOMEPAGE="http://www.sweetscape.com/010editor/templates/"
SRC_URI="http://www.sweetscape.com/010editor/templates/files/010EditorTemplates.zip -> ${P}.zip"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="010 Editor Templates"
HOMEPAGE="https://www.sweetscape.com/010editor/templates/"
SRC_URI="https://www.sweetscape.com/010editor/templates/files/010EditorTemplates.zip -> ${P}.zip"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

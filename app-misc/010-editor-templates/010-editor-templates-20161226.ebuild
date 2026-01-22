# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="010 Editor Templates"
HOMEPAGE="https://www.sweetscape.com/010editor/templates/"
SRC_URI="https://www.sweetscape.com/010editor/templates/files/010EditorTemplates.zip -> ${P}.zip"

S="${WORKDIR}"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}

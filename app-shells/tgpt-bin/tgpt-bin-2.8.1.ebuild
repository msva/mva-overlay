# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI Chatbots in terminal without needing API keys"
HOMEPAGE="https://github.com/aandrew-me/tgpt"

MY_PN="${PN%%-bin}"

SRC_BASE="https://github.com/aandrew-me/${MY_PN}/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${SRC_BASE}/${MY_PN}-linux-amd64 -> ${P}.amd64 )
	arm64? ( ${SRC_BASE}/${MY_PN}-linux-arm64 -> ${P}.arm64 )
	arm? ( ${SRC_BASE}/${MY_PN}-linux-arm -> ${P}.arm )
	x86? ( ${SRC_BASE}/${MY_PN}-linux-i386 -> ${P}.x86 )
"
S="${WORKDIR}"

RDEPEND="!app-shells/tgpt"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
QA_PREBUILT="/usr/bin/${MY_PN}"

src_install() {
	newbin "${DISTDIR}/${A}" "${MY_PN}"
}

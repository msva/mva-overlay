# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Amazfit Bip Tools (for watchface/firmware cooking)"
HOMEPAGE="https://bitbucket.org/valeronm/amazfitbiptools"
SRC_URI="https://bitbucket.org/valeronm/amazfitbiptools/downloads/AmazfitBipTools-${PV}.7z"

LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/p7zip"
RDEPEND="dev-lang/mono"

S="${WORKDIR}"

src_install() {
	insinto /opt/${PN}
	doins *
	make_wrapper "WatchFace" "mono WatchFace.exe" "/opt/${PN}"
}

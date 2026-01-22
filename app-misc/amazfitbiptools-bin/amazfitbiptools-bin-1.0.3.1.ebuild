# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit wrapper

DESCRIPTION="Amazfit Bip Tools (for watchface/firmware cooking)"
HOMEPAGE="https://bitbucket.org/valeronm/amazfitbiptools"
SRC_URI="https://bitbucket.org/valeronm/amazfitbiptools/downloads/AmazfitBipTools-${PV}.7z"

S="${WORKDIR}"

LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/7zip"
RDEPEND="dev-lang/mono"

src_install() {
	insinto /opt/${PN}
	doins -r *
	make_wrapper "WatchFace" "mono WatchFace.exe" "/opt/${PN}"
}

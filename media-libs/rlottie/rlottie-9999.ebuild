# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson patches

MY_SHA="875626965959d8e269ca22175c8e1ad190696c43"

DESCRIPTION="A platform independent standalone library that plays Lottie Animation"
HOMEPAGE="https://github.com/Samsung/rlottie"
LICENSE="LGPL-2.1 FTL MIT"
SLOT="0"
IUSE="cache dumptree log module +threads"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Samsung/${PN}"
else
	SRC_URI="https://github.com/Samsung/${PN}/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"
fi

BDEPEND=">=dev-util/meson-0.50.1"

src_configure() {
	local emesonargs=(
		$(meson_use threads thread)
		$(meson_use cache)
		$(meson_use module)
		$(meson_use log)
		$(meson_use dumptree)
		# -Dcmake=true # Broken anyway
		-Dexample=false # requires EFL
	)
	meson_src_configure
}

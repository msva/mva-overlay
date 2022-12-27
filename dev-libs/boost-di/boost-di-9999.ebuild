# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C++14 Dependency Injection Library"
HOMEPAGE="https://boost-ext.github.io/di"
LICENSE="Boost-1.0"
SLOT="0"

MY_PN="${PN//boost-}"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/boost-ext/${MY_PN}"
else
	SRC_URI="https://github.com/boost-ext/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_SHA:-${PV}}"
fi

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/cmake"

src_prepare() {
	# TODO: maybe replace with non-monkey patch someday?
	sed \
		-e "/install_headers/iinstall_subdir('include',strip_directory: true,install_dir: 'include')" \
		-e "/install_headers/iinstall_subdir('extension/include',strip_directory: true,install_dir: 'include')" \
		-e '/install_headers/d' \
		-i meson.build || die
	default
}

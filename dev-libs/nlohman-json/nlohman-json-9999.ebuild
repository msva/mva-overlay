# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs cmake-utils multilib-minimal git-r3

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="https://github.com/nlohmann/json"
EGIT_REPO_URI="https://github.com/nlohmann/json"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

DOCS=( doc/index.md )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mycmakeargs=(
		-DJSON_BuildTests=OFF
	)
	append-flags "-fPIC"
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	use doc && {
		emake -C doc
	}
}

multilib_src_install() {
	cmake-utils_src_install
	use doc && (
		pushd "${D}/usr/share/doc" &>/dev/null
		mv "${MY_PN}"/* "${PF}"
		rm -r "${MY_PN}"
		popd &>/dev/null
	)
}

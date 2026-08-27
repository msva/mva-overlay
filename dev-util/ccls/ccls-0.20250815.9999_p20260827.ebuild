# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/MaskRay/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	LLVM_COMPAT=( {18..22} )
else
	LLVM_COMPAT=( {18..22} )
fi

inherit cmake llvm-r2 ${GIT_ECLASS}

DESCRIPTION="C/C++/ObjC language server"
HOMEPAGE="https://github.com/MaskRay/ccls"

if [[ ${PV} =~ .9999_p* ]] ; then
	SHA=66481f7b1eb1cf4d1edc12442e275a4efe286850
	S="${WORKDIR}/${PN}-${SHA:-${PV}}"
fi

if [[ ${PV} != *9999 ]] ; then
	SRC_URI="https://github.com/MaskRay/${PN}/archive/${SHA:-${PV}}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	dev-libs/rapidjson
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCCLS_VERSION=${PV}
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DCLANG_LINK_CLANG_DYLIB=1
	)
	cmake_src_configure
}

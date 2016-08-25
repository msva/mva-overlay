# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs cmake-utils multilib-minimal git-r3

DESCRIPTION="C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com"
MY_PN=${PN/++/pp}
EGIT_REPO_URI="https://github.com/weidai11/${MY_PN}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	app-arch/unzip
	sys-devel/libtool
"

src_prepare() {
	rm GNUmakefile
	sed -r \
	-e '/out_source_DOCS_DIR.*html-docs/s@html-docs@html@' \
	-i CMakeLists.txt
	default
	multilib_copy_sources
}

multilib_src_configure() {
	mycmakeargs=(
#		-DBUILD_STATIC=$(usex static-libs ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DDISABLE_ASM=$(usex elibc_Darwin ON OFF)
		-DCRYPTOPP_DATA_DIR="/usr/share/${PF}"
	)
	append-flags "-fPIC"
	cmake-utils_src_configure
}

multilib_src_test() {
	# ensure that all test vectors have Unix line endings
	local file
	for file in TestVectors/* ; do
		edos2unix ${file}
	done

	if ! emake test ; then
		eerror "Crypto++ self-tests failed."
		eerror "Try to remove some optimization flags and reemerge Crypto++."
		die "emake test failed"
	fi
}

multilib_src_install() {
	cmake-utils_src_install
	use doc && (
		pushd "${D}/usr/share/doc" &>/dev/null
		mv "${MY_PN}"/* "${PF}"
		rm -r "${MY_PN}"
		popd &>/dev/null
	)
	dosym "${MY_PN}" "/usr/include/${PN}"
}

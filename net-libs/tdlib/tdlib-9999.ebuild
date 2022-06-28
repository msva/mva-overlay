# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://github.com/tdlib/td"
EGIT_REPO_URI="https://github.com/tdlib/td"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE="+cli doc debug java lto low-ram test"

BDEPEND="
	>=dev-util/cmake-3.0.2
	|| (
		>=sys-devel/gcc-4.9:=
		>=sys-devel/clang-3.4:=
	)
	dev-util/gperf
	dev-lang/php[cli]
	doc? ( app-doc/doxygen )
	java? ( virtual/jdk:= )
"
RDEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib
"

# According to documentation, LTO breaks build of java bindings. But actually it builds fine for me.
REQUIRED_USE="?? ( lto java )"

DOCS=( README.md )

PATCHES=( "${FILESDIR}/${P}-fix-runpath.patch" )

src_prepare() {
	if use test; then
		sed -i -e '/run_all_tests/! {/all_tests/d}' \
			test/CMakeLists.txt || die
	else
		sed -i \
			-e '/enable_testing/d' \
			-e '/add_subdirectory.*test/d' \
			CMakeLists.txt || die
	fi
	# user reported that for now, tests segfaults on glibc and musl

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DCMAKE_INSTALL_PREFIX=/usr
		-DTD_ENABLE_JNI=$(usex java ON OFF)
		-DTD_ENABLE_LTO=$(usex lto ON OFF)

		# According to TDLib build instructions, DOTNET=ON is only needed
		# for using tdlib from C# under Windows through C++/CLI
		-DTD_ENABLE_DOTNET=OFF

		# -DTD_EXPERIMENTAL_WATCH_OS=$(usex watch-os ON OFF) # Requires "Foundation" library. TBD.
		# -DEMSCRIPTEN=$(usex javascript ON OFF) # Somehow makes GCC to stop seeing pthreads.h
	)
	cmake_src_configure

	if use low-ram; then
		cmake --build "${BUILD_DIR}" --target prepare_cross_compiling || die
		php SplitSource.php || die
	fi
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen Doxyfile || die "Could not build docs with doxygen"
	fi
}

src_install() {
	use low-ram && php SplitSource.php --undo

	cmake_src_install

	# TODO: USE=java installs crap into /usr/bin:
	# /usr/bin/td/generate/scheme/td_api.tlo
	# /usr/bin/td/generate/scheme/td_api.tl
	# /usr/bin/td/generate/TlDocumentationGenerator.php
	# /usr/bin/td/generate/JavadocTlDocumentationGenerator.php
	# Need to fix this

	use cli && dobin "${BUILD_DIR}"/tg_cli

	use doc && local HTML_DOCS=( docs/html/. )
	einstalldocs
}

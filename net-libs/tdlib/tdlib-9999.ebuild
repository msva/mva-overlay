# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 java-pkg-opt-2

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://github.com/tdlib/td"
EGIT_REPO_URI="https://github.com/tdlib/td"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="+cli doc debug +tde2e java lto low-ram test"

BDEPEND="
	dev-util/gperf
	low-ram? ( dev-lang/php[cli] )
	doc? ( app-text/doxygen )
	java? ( virtual/jdk:= )
"
RDEPEND="
	dev-libs/openssl:0=
	virtual/zlib
"

if [[ "${PV}" == *_pre* ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	EGIT_COMMIT_DATE="${PV##*_}"
	# NOTE: in case of making that PV for "not yet have new release, but last commit made a while ago",
	# name ebuild after that scheme:
	# ${PN}-${NEXT_PV}_pre${LCD}
	# where LCD = "last commit date + 1 day",
	# to safely fetch it, and not some of the previous ones.
fi

# According to documentation, LTO breaks build of java bindings. But actually it builds fine for me.
REQUIRED_USE="?? ( lto java )"

DOCS=( README.md )

RESTRICT="!test? ( test )"

src_prepare() {
	sed -e '/add_library(/s/ STATIC//' \
		-i CMakeLists.txt */CMakeLists.txt || die
	sed -e '/set(INSTALL_STATIC_TARGETS /s/ tdjson_static TdJsonStatic//' \
		-e '/generate_pkgconfig(tdjson_static /d' \
		-i CMakeLists.txt || die

	# Benchmarks take way too long to compile
	sed -e '/add_subdirectory(benchmark)/d' \
		-i CMakeLists.txt || die

	# Fix tests linking
	sed -e 's/target_link_libraries(run_all_tests PRIVATE /&tdmtproto /' \
		-i test/CMakeLists.txt

	# if use test; then
	# 	sed -i -e '/run_all_tests/! {/all_tests/d}' \
	# 		test/CMakeLists.txt || die
	# else
	# 	sed -i \
	# 		-e '/enable_testing/d' \
	# 		-e '/add_subdirectory.*test/d' \
	# 		CMakeLists.txt || die
	# fi
	# # user reported that for now, tests segfaults on glibc and musl

	java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DCMAKE_INSTALL_PREFIX=/usr
		-DTD_ENABLE_JNI=$(usex java ON OFF)
		-DTD_ENABLE_LTO=$(usex lto ON OFF)
		-DTDE2E_INSTALL_INCLUDES=ON

		# According to TDLib build instructions, DOTNET=ON is only needed
		# for using tdlib from C# under Windows through C++/CLI
		-DTD_ENABLE_DOTNET=OFF

		# -DTD_EXPERIMENTAL_WATCH_OS=$(usex watch-os ON OFF) # Requires "Foundation" library. TBD.
		# -DEMSCRIPTEN=$(usex javascript ON OFF) # Somehow makes GCC to stop seeing pthreads.h
	)

	if use java; then
		export JAVA_HOME="$(java-config -g JAVA_HOME)"
		export JAVA_AWT_INCLUDE_PATH="${JAVA_HOME}/include"
		export JAVA_JVM_LIBRARY="${JAVA_HOME}/lib/server/libjvm.so"
	fi

	cmake_src_configure

	if use low-ram; then
		cmake --build "${BUILD_DIR}" --target prepare_cross_compiling || die
		php SplitSource.php || die
	fi

	if use tde2e; then
		# Generate cmake configuration files for the e2e-only variant
		# These are required by certain programs which depend on "tde2e"
		mycmakeargs+=( -DTD_E2E_ONLY=ON )
		BUILD_DIR="${S}_tde2e" cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen Doxyfile || die "Could not build docs with doxygen"
	fi

	if use tde2e; then
		BUILD_DIR="${S}_tde2e" cmake_src_compile
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

	if use tde2e; then
		# Install the tde2e headers
		insinto /usr/include/td/e2e
		doins tde2e/td/e2e/e2e_api.h tde2e/td/e2e/e2e_errors.h

		# Install the tde2e cmake files
		cd "${S}_tde2e" || die
		insinto /usr/$(get_libdir)/cmake/tde2e
		doins tde2eConfig.cmake tde2eConfigVersion.cmake
		doins CMakeFiles/Export/*/tde2eStaticTargets*.cmake
	fi
}

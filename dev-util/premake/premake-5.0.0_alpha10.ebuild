# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator eutils flag-o-matic

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="https://github.com/premake/premake-core/releases/download/v${PV/_/-}/${P/_/-}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

S="${WORKDIR}/${P/_/-}"
B_DIR="build/gmake.unix/"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	local sedargs=();
	local c="Release";

	use debug && c="Debug";

	# use system-wide libaries instead of bundled!
	for lib in zip zlib curl; do
		sedargs+=(-e "/LIBS \+=/s|bin/${c}/lib${lib}-lib.a|-l${lib//lib}|")
		sedargs+=(-e "/LDDEPS \+=/s|bin/${c}/lib${lib}-lib.a||")
		sedargs+=(-e "/INCLUDES \+=/s|-I[^ ]*${lib}[^ ]*||")

		sed -r -i \
			-e "/^PROJECTS :=/s|${lib}-lib||" \
			-e "/^contrib: /s|${lib}-lib||" \
			-e "/^Premake5: /s|${lib}-lib||" \
			"${S}/${B_DIR}/Makefile"

		rm -r "${S}/contrib/"*"${lib}"
		rm -r "${S}/${B_DIR}/${lib}-lib.make"
	done
	# ^ TODO: unbundle Lua too!

	# QA: We'll strip built binaries ourselves, so, buildsystem shouldn't do that!
	sedargs+=(-e "/ALL_LDFLAGS \+=/s|\-s||")
	sed -r -i \
		"/if not cfg.flags.Symbols then/{n;d}" \
		"${S}"/src/tools/snc.lua
	# QA: ^^^

	sed -r -i "${sedargs[@]}" \
		"${S}"/build/gmake.unix/Premake5.make

	append-cflags "-Wno-unused-parameter"

	default
}

src_compile() {
	local c="release";
	use debug && c="debug";
	emake -C "${B_DIR}" config=${c}
}

src_install() {
	dobin bin/release/premake${SLOT}
}

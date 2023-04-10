# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go-module qmake-utils toolchain-funcs

DESCRIPTION="Collection of QML tools, including qml-lsp, qml-dap, and qml-refactor-fairy"
HOMEPAGE="https://invent.kde.org/sdk/qml-lsp"

EGIT_REPO_URI="https://invent.kde.org/sdk/qml-lsp.git"

LICENSE="Apache-2.0 GPL-3+ MIT"
SLOT="0"

DEPEND="dev-libs/tree-sitter"
RDEPEND="
	${DEPEND}
	dev-qt/qtcore
"
BDEPEND="
	dev-lang/go
	dev-util/qbs
"

PATCHES=( "${FILESDIR}"/${PN}-0.2.0-find-qmake5.patch )

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}


src_prepare() {
	# QBS Authors is fucking sadists.
	# And people who took already dead (and such complicated) buildsystems
	# for building a small part of their code is even more sadistic.
	qbs setup-qt --settings-dir "${T}" "$(qt5_get_bindir)/qmake" qmake
	qbs setup-toolchains --settings-dir "${T}" "$(tc-getCC)" cc
	sed -r \
		-e "s@\\\\cc\\\\@\\\\gentoo\\\\@" \
		-e "s@\\\\qmake\\\\@\\\\gentoo\\\\@" \
		-i "${T}"/qbs/*/qbs.conf
	# Fucking backslash escaping!!!
	default
}

src_compile() {
	pushd "${S}/debugclient/lib"
	qbs build --settings-dir "${T}" profile:gentoo qbs.installPrefix:"/usr" qbs.installDir:"$(get_libdir)"
	popd
	for cmd in ./cmd/qml-{doxygen,lint,lsp,refactor-fairy,dap,dbg}; do
		ego build -ldflags '-linkmode external' "${cmd}"
	done
}

src_test() {
	ego test ./qmltypes ./analysis
}

src_install() {
	pushd "${S}/debugclient/lib"
	qbs install --install-root "${D}" --settings-dir "${T}" profile:gentoo
	popd
	dobin qml-{doxygen,lint,lsp,refactor-fairy,dap,dbg}
	einstalldocs
}

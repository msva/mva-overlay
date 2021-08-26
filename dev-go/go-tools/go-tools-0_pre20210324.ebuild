# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="golang.org/x/tools"

EGO_VENDOR=(
	"golang.org/x/net e18ecbb051101a46fc263334b127c89bc7bff7ea github.com/golang/net"
	"golang.org/x/sync 036812b2e83c0ddf193dd5a34e034151da389d09 github.com/golang/sync"
	"golang.org/x/xerrors 5ec99f83aff198f5fbd629d6c8d8eb38a04218ca github.com/golang/xerrors"
	"github.com/yuin/goldmark v1.2.1"
	"golang.org/x/sys 1e4c9ba3b0c4fcddbe90893331bdc829813066a1 github.com/golang/sys"
	"golang.org/x/mod 19d50cac98aa7a8e0a0c8b6a9bfd3a99e653c0cc github.com/golang/mod"
	#"golang.org/x/mod v0.4.1"
)

EGIT_COMMIT="d8aeb16bb5b3e0e830afa773937316886ad84919"
ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Tools that support the Go programming language (godoc, etc.)"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
GO_FAVICON="go-favicon-20181103162401.ico"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}
	mirror://gentoo/${GO_FAVICON}
	https://dev.gentoo.org/~zmedico/distfiles/${GO_FAVICON}"
LICENSE="BSD"
SLOT="0/${PVR}"
S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	default
	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/${GO_FAVICON} "godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i godoc/static/gen.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i godoc/static/godoc.html || die
	sed -e 's:TestDryRun(:_\0:' \
		-e 's:TestFixImports(:_\0:' \
		-i cmd/fiximports/main_test.go || die
	sed -e 's:TestWebIndex(:_\0:' \
		-e 's:TestTypeAnalysis(:_\0:' \
		-i cmd/godoc/godoc_test.go || die
	sed -e 's:TestApplyFixes(:_\0:' \
		-i go/analysis/internal/checker/checker_test.go || die
	sed -e 's:TestIntegration(:_\0:' \
		-i go/analysis/unitchecker/unitchecker_test.go || die
	sed -e 's:TestVeryLongFile(:_\0:' \
		-i go/internal/gcimporter/bexport_test.go || die
	sed -e 's:TestImportStdLib(:_\0:' \
		-i go/internal/gcimporter/gcimporter_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-e 's:TestStdlib(:_\0:' \
		-i go/loader/stdlib_test.go || die
	sed -e 's:TestCgoMissingFile(:_\0:' \
		-e 's:TestCgoNoCcompiler(:_\0:' \
		-e 's:TestConfigDefaultEnv(:_\0:' \
		-e 's:TestLoadSyntaxOK(:_\0:' \
		-e 's:TestMissingDependency(:_\0:' \
		-e 's:TestName_Modules(:_\0:' \
		-e 's:TestName_ModulesDedup(:_\0:' \
		-e 's:TestPatternPassthrough(:_\0:' \
		-i go/packages/packages_test.go || die
	sed -e 's:TestCgoOption(:_\0:' \
		-i go/packages/stdlib_test.go || die
	sed -e 's:TestStdlib(:_\0:' \
		-i go/ssa/stdlib_test.go || die
	sed -e 's:TestLocalPackagePromotion(:_\0:' \
		-e 's:TestLocalPrefix(:_\0:' \
		-e 's:TestSimpleCases(:_\0:' \
		-i internal/imports/fix_test.go || die
	sed -e 's:TestFindModFileModCache(:_\0:' \
		-e 's:TestInvalidModCache(:_\0:' \
		-e 's:TestModeGetmodeVendor(:_\0:' \
		-e 's:TestModCase(:_\0:' \
		-e 's:TestModDomainRoot(:_\0:' \
		-e 's:TestModList(:_\0:' \
		-e 's:TestModLocalReplace(:_\0:' \
		-e 's:TestModMultirepo3(:_\0:' \
		-e 's:TestModMultirepo4(:_\0:' \
		-e 's:TestModReplace1(:_\0:' \
		-e 's:TestModReplace2(:_\0:' \
		-e 's:TestModReplace3(:_\0:' \
		-e 's:TestModReplaceImport(:_\0:' \
		-e 's:TestScanNestedModuleInLocalReplace(:_\0:' \
		-i internal/imports/mod_test.go || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678964
	export GOPATH="${WORKDIR}/${P}" GO111MODULE=on GOFLAGS="-mod=vendor -v -x"

	go install -work ${EGO_BUILD_FLAGS} \
		$(GOPATH="${WORKDIR}/${P}" go list ./...) || die
die
}

src_test() {
	go test -work "${EGO_PN}/..." || die
}

src_install() {
	rm -rf vendor || die
	pushd "${WORKDIR}/${P}"
	golang_install_pkgs
	popd >/dev/null

	# bug 558818: install binaries in $GOROOT/bin to avoid file collisions
	exeinto "$(go env GOROOT)/bin"
	doexe "${WORKDIR}/${P}"/bin/*
	dodir /usr/bin
	ln "${ED}/$(go env GOROOT)/bin/godoc" "${ED}/usr/bin/godoc" || die
die
}

# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Disk usage analyzer with console interface written in Go"
HOMEPAGE="https://github.com/dundee/gdu"
SRC_URI="https://github.com/dundee/gdu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# SRC_URI+=" https://gentoo.kropotkin.rocks/go-pkgs/${P}-vendor.tar.xz"
SRC_URI+=" https://github.com/spikyatlinux/gdu-vendor-files/releases/download/v${PV}/${P}-vendor.tar.gz"
# TODO: make my own tarball and place it somewhere
# cd ${S}
# go mod vendor
# tar -czvf /tmp/${P}-vendor.tar.gz ../${P}/vendor

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	# default
	mkdir -p "${S}"
	ln -s ../vendor "${S}"/vendor # current tarball author made it bad way
	go-module_src_unpack
}

src_compile() {
	local my_ldflags=(
		# -s -w
		# 👆 causes QA notice about pre-stripped binary
		-X "'github.com/dundee/gdu/v5/build.Version=${PV}'"
		-X "'github.com/dundee/gdu/v5/build.Time=$(date +%Y-%m-%d\ %H:%M:%S)'"
		-X "'github.com/dundee/gdu/v5/build.User=portage (Gentoo Package Manager)'"
	)
	ego build -ldflags "${my_ldflags[*]}" -v -x -work -o "${PN}" "./cmd/${PN}"
}

src_install() {
	einstalldocs
	dodoc -r README.md gdu.1.md
	dobin gdu
	doman gdu.1
}

src_test() {
	ego test ./...
}

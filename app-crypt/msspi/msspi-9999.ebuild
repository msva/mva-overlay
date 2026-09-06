# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="TLS client/server framework mimics OpenSSL to SSP interface"
HOMEPAGE="https://github.com/deemru/msspi"
EGIT_REPO_URI="https://github.com/deemru/msspi"
if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
else
	SRC_URI="${EGIT_REPO_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

QA_SONAME="/usr/lib/libmsspi.so /usr/lib64/libmsspi.so"

src_compile() {
	emake -C build_linux shared $(usex static-libs "all" "")
}

src_install() {
	local LIB=${ED}/usr/$(get_libdir)
	mkdir -p "${LIB}"
	cp -a build_linux/*.{so,a} ${LIB}/
}

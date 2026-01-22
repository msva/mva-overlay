# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit go-module git-r3

DESCRIPTION="AI Chatbots in terminal without needing API keys"
HOMEPAGE="https://github.com/aandrew-me/tgpt"

EGIT_REPO_URI="https://github.com/aandrew-me/${PN}"

# SRC_URI="https://github.com/aandrew-me/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# 👆 I'm too lazy for bundling deps in tarball and putting it in my devspace
# (or search a hosting for it).
# So I'll just use go-module_live_vendor, which requires live ebuild 🤷

[[ "${PV}" == *9999* ]] || EGIT_COMMIT="v${PV}"
[[ "${PV}" == *9999* ]] || KEYWORDS="~amd64 ~arm ~arm64 ~x86"
# XXX: kludge for eix
# TODO: other go-supported arches

RDEPEND="!app-shells/tgpt-bin"

LICENSE="GPL-3"
SLOT="0"

# QA_PREBUILT="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_prepare() {
	default
	# get rid of auto-updating functionality
	sed -r \
		-e '/case\ \*isUpdate:/,/helper.Update\([^\))]*\)/d' \
		-e '/isUpdate.*Update\ program/d' \
		-e '/executablePath/d' \
		-e '/execPath,\ err/,/\t\}/d' \
		-i main.go || die
	sed -r \
		-e '/^func\ Update\([^\)]*\)\ \{/,/^\}/d' \
		-e '/fmt.Print.*Update\ program/{s@.*@//@}' \
		-e '/golang.org.*semver/d' \
		-e '/github.com\/aandrew-me\/tgpt\/v2\/src\/client/d' \
		-i src/helper/helper.go || die
}

src_compile() {
	ego build
}

src_install() {
	dobin "${PN}"
}

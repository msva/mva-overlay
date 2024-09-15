# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="AI Chatbots in terminal without needing API keys"
HOMEPAGE="https://github.com/aandrew-me/tgpt"

if ! [[ "${PV}" == *9999* ]]; then
	SRC_URI="https://github.com/aandrew-me/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aandrew-me/${PN}"
fi
[[ "${PV}" == *9999* ]] || KEYWORDS="~amd64 ~arm ~arm64 ~x86"
# XXX: kludge for eix
# TODO: other go-supported arches

RDEPEND="!app-shells/tgpt-bin"

LICENSE="GPL-3"
SLOT="0"

src_unpack() {
	[[ "${PV}" == *9999* ]] && git-r3_src_unpack
	default
	go-module_live_vendor
}

src_prepare() {
	default
	# get rid of auto-updating functionality
	sed -r \
		-e '/case\ \*isUpdate:/,/update\(\)/d' \
		-e '/fmt.Printf.*Update\ program\ /{s@.*@fmt.Printf\(""\)@}' \
		-i main.go || die
	sed -r \
		-e '/^func\ update\(\)\ \{/,/^\}/d' \
		-e '/golang.org.*semver/d' \
		-i helper.go || die
}

src_compile() {
	ego build -trimpath -ldflags="-s -w"
}

src_install() {
	dobin "${PN}"
}

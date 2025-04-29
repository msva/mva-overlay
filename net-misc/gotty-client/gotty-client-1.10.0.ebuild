# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 shell-completion

DESCRIPTION="A terminal client for GoTTY"
HOMEPAGE="https://github.com/moul/gotty-client"

EGIT_REPO_URI="https://github.com/moul/gotty-client"
if ! [[ "${PV}" == *9999* ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="bash-completion zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror strip"

DOCS=( README.md )

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build \
		-v -ldflags "-s -w" \
		./cmd/gotty-client
}

src_test() {
	ego test -v ./...
}

src_install() {
	dobin gotty-client
	einstalldocs

	if use bash-completion; then
		newbashcomp contrib/completion/bash_autocomplete ${PN}
	fi

	if use zsh-completion; then
		newzshcomp contrib/completion/zsh_autocomplete _${PN}
	fi
}

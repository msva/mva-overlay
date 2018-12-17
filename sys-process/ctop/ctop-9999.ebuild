# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/bcicen/${PN}"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
EGIT_MIN_CLONE_TYPE="single+tags"
S="${EGIT_CHECKOUT_DIR}"

EGIT_REPO_URI="https://${EGO_PN}"

inherit golang-base git-r3

KEYWORDS=""

DESCRIPTION="Top-like interface for container-metrics"
HOMEPAGE="https://ctop.sh https://github.com/bcicen/ctop"
SRC_URI="${EGO_VENDOR_URI}"
LICENSE="MIT"
SLOT="0"
IUSE="hardened"

RESTRICT="test"

src_unpack() {
	git-r3_src_unpack
	local deps=(
		"github.com/fsouza/go-dockerclient::" # 318513eb1ab27495afbc67f671ba1080513d8aa0
		"github.com/docker/docker::"
		"github.com/docker/go-units::"
		"github.com/gizak/termui::github.com/bcicen/termui"
		"github.com/jgautheron/codename-generator::"
		"github.com/mattn/go-runewidth::"
		"github.com/mitchellh/go-wordwrap::"
		"github.com/nsf/termbox-go::"
		"github.com/op/go-logging::" # 1.0.0
		"github.com/nu7hatch/gouuid::"
		"github.com/opencontainers/runc::" # 0.1.1
		"github.com/BurntSushi/toml::"
		"github.com/Nvveen/Gotty::"
		"github.com/c9s/goprocinfo::"
		"github.com/sirupsen/logrus::"
		"golang.org/x/sys::github.com/golang/sys"
		"golang.org/x/crypto::github.com/golang/crypto"
#		"github.com/Microsoft/go-winio" # 0.3.8
#		"golang.org/x/net::github.com/golang/net"
#		"github.com/hashicorp/go-cleanhttp::"
#		"github.com/maruel/panicparse::"
	)
	for d in ${deps[@]}; do
		IFS=":" read EGIT_CHECKOUT_DIR EGIT_COMMIT EGIT_REPO_URI <<< "${d}"
		EGIT_REPO_URI=https://${EGIT_REPO_URI:-${EGIT_CHECKOUT_DIR}}
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGIT_CHECKOUT_DIR}"
		git-r3_src_unpack
	done
}

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	GOPATH="${WORKDIR}/${P}"\
		go build -ldflags "-X main.version=${PV} -X main.build=${EGIT_COMMIT:0:7}" -o ${PN} || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}

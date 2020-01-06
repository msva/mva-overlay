# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Change this when you update the ebuild
GIT_COMMIT="${PV}"
EGO_PN="github.com/junegunn/${PN}"
# Note: Keep EGO_VENDOR in sync with glide.lock
EGO_VENDOR=(
	#"github.com/codegangsta/cli c6af8847eb2b"
	#"github.com/gdamore/encoding b23993cbb635"
	#"github.com/gdamore/tcell 0a0db94084df"
	#"github.com/lucasb-eyer/go-colorful c900de9dbbc7"
	#"github.com/Masterminds/semver 15d8430ab864"
	#"github.com/Masterminds/vcs 6f1c6d150500"
	"github.com/mattn/go-isatty 66b8e73f3f5c"
	"github.com/mattn/go-runewidth 14207d285c6c"
	"github.com/mattn/go-shellwords v1.0.3"
	#"github.com/mitchellh/go-homedir b8bc1bf76747"
	"golang.org/x/crypto 558b6879de74 github.com/golang/crypto"
	"golang.org/x/sys a5b02f93d862 github.com/golang/sys"
	#"golang.org/x/text 4ee4af566555 github.com/golang/text"
	#"gopkg.in/yaml.v2 287cf08546ab github.com/go-yaml/yaml"
)

inherit bash-completion-r1 golang-vcs-snapshot

DESCRIPTION="A general-purpose command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
ARCHIVE_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"
RESTRICT="mirror network-sandbox"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86" # Untested: arm arm64 x86
IUSE="debug tmux"

RDEPEND="tmux? ( app-misc/tmux )"

DOCS=( CHANGELOG.md README.md )
QA_PRESTRIPPED="usr/bin/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "main.revision=${GIT_COMMIT:0:7}"
	)
	local mygoargs=(
		-v
		#"-buildmode=$(usex pie pie exe)"
		"-buildmode=pie"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)
	go build "${mygoargs[@]}" || die
}

src_test() {
	go test -v ./src{,/algo,/tui,/util} || die
}

src_install() {
	dobin fzf
	use debug && dostrip -x /usr/bin/fzf
	einstalldocs

	doman man/man1/fzf.1

	insinto /etc/bash/bashrc.d
	newins shell/key-bindings.bash fzf.bash
	echo 'complete -o default -F _fzf_opts_completion fzf' >> shell/completion.bash # QA-workaround
	newbashcomp shell/completion.bash "${PN}"

	insinto /usr/share/nvim/runtime/plugin
	doins plugin/fzf.vim

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/fzf.vim
	dodoc README-VIM.md

	insinto /usr/share/zsh/site-functions
	newins shell/completion.zsh _fzf
	insinto /usr/share/zsh/site-contrib/
	newins shell/key-bindings.zsh fzf.zsh

	if use tmux; then
		dobin bin/"${PN}"-tmux
		bashcomp_alias "${PN}" "${PN}"-tmux
		doman man/man1/"${PN}"-tmux.1
	fi
}

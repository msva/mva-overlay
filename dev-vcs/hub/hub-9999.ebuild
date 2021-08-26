# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 readme.gentoo-r1 go-module git-r3

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.0"
	"github.com/BurntSushi/toml v0.3.0/go.mod"
	"github.com/atotto/clipboard v0.0.0-20171229224153-bc5958e1c833"
	"github.com/atotto/clipboard v0.0.0-20171229224153-bc5958e1c833/go.mod"
	"github.com/google/go-cmp v0.4.0"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20170619183022-cd60e84ee657"
	"github.com/kballard/go-shellquote v0.0.0-20170619183022-cd60e84ee657/go.mod"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-colorable v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.3"
	"github.com/mattn/go-isatty v0.0.3/go.mod"
	"github.com/mitchellh/go-homedir v0.0.0-20161203194507-b8bc1bf76747"
	"github.com/mitchellh/go-homedir v0.0.0-20161203194507-b8bc1bf76747/go.mod"
	"github.com/russross/blackfriday v0.0.0-20180526075726-670777b536d3"
	"github.com/russross/blackfriday v0.0.0-20180526075726-670777b536d3/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v0.0.0-20170918181015-86672fcb3f95"
	"github.com/shurcooL/sanitized_anchor_name v0.0.0-20170918181015-86672fcb3f95/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20191002035440-2ec189313ef0"
	"golang.org/x/net v0.0.0-20191002035440-2ec189313ef0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190531175056-4c3a928424d2"
	"golang.org/x/sys v0.0.0-20190531175056-4c3a928424d2/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.0.0-20190319135612-7b8349ac747c"
	"gopkg.in/yaml.v2 v2.0.0-20190319135612-7b8349ac747c/go.mod"
)

go-module_set_globals

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

SRC_URI="${EGO_SUM_SRC_URI}"
EGIT_REPO_URI="https://github.com/github/hub"

DEPEND="
	>=dev-lang/go-1.5.1:*
"
RDEPEND=">=dev-vcs/git-1.7.3"

DOC_CONTENTS="You may want to add 'alias git=hub' to your .{csh,bash}rc"

src_unpack() {
	git-r3_src_unpack
	go-module_src_unpack
	go-module_live_vendor
}

src_compile() {
	export GOFLAGS="${GOFLAGS} -mod=vendor"
	emake bin/hub man-pages
}

#src_test() {
#	./script/test || die
#}

src_install() {
	readme.gentoo_create_doc

	dobin bin/hub

	doman share/man/man1/*.1
	dodoc README.md

	newbashcomp etc/${PN}.bash_completion.sh ${PN}

	insinto /usr/share/zsh/site-functions
	newins etc/hub.zsh_completion _${PN}
}

pkg_postinst() {
	readme.gentoo_print_elog
}

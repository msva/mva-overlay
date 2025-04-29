# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 shell-completion

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/mislav/hub"

SRC_URI="${EGO_SUM_SRC_URI}"
EGIT_REPO_URI="https://github.com/mislav/hub"

LICENSE="MIT"
SLOT="0"

BDEPEND="sys-apps/groff"
RDEPEND=">=dev-vcs/git-1.7.3"

DOCS=( README.md )

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	# The eclass setting GOFLAGS at all overrides this default
	# in the upstream Makefile. It'll *FALL BACK* to bundled/vendored
	# modules but without this, it'll try fetching. On platforms
	# without network-sandbox (or relying on it), this is not okay.
	export GOFLAGS="${GOFLAGS} -mod=vendor"
	emake bin/hub man-pages
}

src_install() {
	dobin bin/hub

	doman share/man/man1/*.1

	newbashcomp etc/${PN}.bash_completion.sh ${PN}

	newzshcomp etc/${PN}.zsh_completion _${PN}

	insinto /usr/share/vim/vimfiles
	doins -r share/vim/vimfiles/*

	einstalldocs
}

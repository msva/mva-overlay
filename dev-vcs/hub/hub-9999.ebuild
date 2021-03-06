# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs bash-completion-r1 readme.gentoo-r1

DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://github.com/github/hub"

EGO_PN="github.com/github/hub"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/go-1.5.1:*
	app-text/ronn
"
RDEPEND=">=dev-vcs/git-1.7.3"

DOC_CONTENTS="You may want to add 'alias git=hub' to your .{csh,bash}rc"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	sed -r \
		-e '/^bin\/ronn/,+2d' \
		-e 's@^(%.1: %.1.ronn) bin/ronn@\1@' \
		-e 's@bin/(ronn --organization)@\1@' \
		-i Makefile

	default
	export GOPATH="${S}:${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo"
}

src_compile() {
	emake man-pages
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

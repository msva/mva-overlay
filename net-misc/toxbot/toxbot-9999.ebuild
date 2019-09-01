# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="Tox groupchats bot"
HOMEPAGE="https://github.com/JFreegman/ToxBot"
EGIT_REPO_URI="https://github.com/JFreegman/ToxBot"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="net-libs/tox[av]"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
			-e 's/@$(CC)/$(CC)/' \
			Makefile || die
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		USER_CFLAGS="${CFLAGS}" \
		USER_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${S}/toxbot"
}

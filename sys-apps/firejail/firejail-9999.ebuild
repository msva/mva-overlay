# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="a SUID sandbox program using linux namespaces"
HOMEPAGE="https://l3net.wordpress.com/projects/firejail/"

SRC_URI=""
EGIT_REPO_URI="https://github.com/netblue30/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="apparmor +bind +chroot +file-transfer +network
	network-restricted +seccomp +userns x11"

DEPEND="
	!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )
"
RDEPEND="
	${DEPEND}
	x11? (
		x11-base/xorg-server[xcsecurity]
		x11-wm/xpra[client,server]
	)
"

src_prepare() {
	default
	sed \
		-e 's#/usr/bin/zsh#/bin/zsh#g' \
		-i \
			src/man/${PN}.txt \
			src/${PN}/usage.c \
			src/${PN}/main.c
	find -name Makefile.in -exec sed -i -r \
		-e '/^\tinstall .*COPYING /d' \
		-e '/CFLAGS/s: (-O2|-ggdb) : :g' \
		-e '1iCC=@CC@' {} + || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable apparmor)
		$(use_enable bind)
		$(use_enable chroot)
		$(use_enable file-transfer)
		$(use_enable network)
		$(use_enable seccomp)
		$(use_enable userns)
		$(use_enable x11)
	)
	use network-restricted && myeconfargs+=( --enable-network=restricted )
	econf "${myeconfargs[@]}"
}

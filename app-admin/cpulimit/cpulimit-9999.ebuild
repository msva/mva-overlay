# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit toolchain-funcs git-r3

DESCRIPTION="Limits the CPU usage of a process"
HOMEPAGE="https://cpulimit.sourceforge.net"
EGIT_REPO_URI="https://github.com/opsengine/cpulimit"

LICENSE="GPL-2"
SLOT="0"

PATCHES="${FILESDIR}/${P}-makefile.patch"

src_prepare() {
	default
	sed -r \
		-e '/sys\/sysctl.h/d' \
		-i src/cpulimit.c
	sed -r \
		-e '/signal.h.*$/a#include <libgen.h>' \
		-i src/process_group.c
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dosbin src/cpulimit
	doman "${FILESDIR}/cpulimit.8"
}

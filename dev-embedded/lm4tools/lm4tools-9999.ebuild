# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit toolchain-funcs git-r3

DESCRIPTION="Provides lm4flash and lmicdiusb for developing on the TI Stellaris Launchpad"
HOMEPAGE="https://github.com/utzig/lm4tools"
EGIT_REPO_URI="https://github.com/utzig/lm4tools.git"

LICENSE="GPL-2+ MIT"
SLOT="0"

RDEPEND="virtual/libusb:1"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare () {
	sed -e "s:gcc:$(tc-getCC):" -i lm4flash/Makefile || die
	default
}

src_compile () {
	CC=$(tc-getCC) emake -C lmicdiusb
	emake -C lm4flash
}

src_install () {
	dobin lm4flash/lm4flash
	dobin lmicdiusb/lmicdi
	dodoc README.md lmicdiusb/{README,commands.txt}
}

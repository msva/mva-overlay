# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI="https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

S="${WORKDIR}/ZeroTierOne-${PV}"

RDEPEND="
	dev-libs/json-glib:=
	net-libs/http-parser:=
	net-libs/libnatpmp:=
	net-libs/miniupnpc:=
"

DEPEND="${RDEPEND}"

DOCS=( README.md AUTHORS.md )

src_prepare() {
	sed -i \
		-e '$aFORCE:' \
		-e '/^install/,${/gzip -9/d;/rm -f/d;/share\/man/d}' \
		-e '/^uninstall:/,${d};' \
		make-linux.mk || die
	default
}

src_compile() {
	append-cflags -fPIE
	append-cxxflags -fPIE
	append-ldflags -pie
	append-ldflags -Wl,-z,relro,-z,now # from original makefile
	append-ldflags -Wl,-z,noexecstack # QA
	emake \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		STRIP=: \
		one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service
	doman doc/zerotier-{cli.1,idtool.1,one.8}
}

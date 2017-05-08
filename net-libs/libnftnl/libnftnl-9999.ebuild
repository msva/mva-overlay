# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs eutils autotools git-r3

DESCRIPTION="Netlink API to the in-kernel nf_tables subsystem"
HOMEPAGE="http://netfilter.org/projects/nftables/"
SRC_URI=""
EGIT_REPO_URI="git://git.netfilter.org/libnftnl"

LICENSE="GPL-2"
SLOT="0/4"
KEYWORDS=""
IUSE="examples json static-libs test"

RDEPEND="
	>=net-libs/libmnl-1.0.0
	json? ( >=dev-libs/jansson-2.3 )
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

REQUIRED_USE="test? ( json )"

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with json json-parsing)
}

src_install() {
	default
	gen_usr_ldscript -a nftnl
	prune_libtool_files

	if use examples; then
		find examples/ -name 'Makefile*' -delete
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

src_test() {
	default
	cd tests || die
	./test-script.sh || die
}

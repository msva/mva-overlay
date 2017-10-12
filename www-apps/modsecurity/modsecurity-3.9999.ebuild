# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3
# is multilib needed? I don't know any 32bit proprietary software using it so far...

DESCRIPTION="Open source, cross platform web application firewall (WAF) engine"
HOMEPAGE="https://modsecurity.org/"

EGIT_REPO_URI="https://github.com/SpiderLabs/ModSecurity"

EGIT_BRANCH="v3/master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="afl +geoip"
RDEPEND="
	afl? ( app-forensics/afl )
	net-misc/curl
	geoip? ( dev-libs/geoip )
	dev-libs/libxml2
	dev-libs/libpcre
	dev-libs/yajl
"
DEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
"

src_prepare() {
	default
	use afl && export CC=afl-clang-fast CXX=afl-clang-fast++
	eautoreconf
}

src_configure() {
	local myconf

	myconf=(
		$(use_enable afl afl-fuzz)
		$(use_with geoip)
		--enable-parser-generation
		--disable-doxygen-doc
		# ^^^ enabling and disabling this change nothing in build directory
		--disable-examples
		# ^^^ useless binaries (plus reading_logs_via_rule_message.h header)
		--without-lmdb
		# ^^^ https://github.com/SpiderLabs/ModSecurity/issues/1586
	)

	econf ${myconf[@]}
}

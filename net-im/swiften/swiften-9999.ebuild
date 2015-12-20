# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
SCONS_MIN_VERSION="1.2"
LANGS=" ca de es fr hu nl pl ru se sk"

[[ ${PV} = *9999* ]] && VCS="git-r3"

inherit eutils scons-utils toolchain-funcs ${VCS}

DESCRIPTION="Just a perfect C++ XMPP library"
HOMEPAGE="http://swift.im/"

#MY_P="swift-${PV}"
#S="${WORKDIR}/${MY_P}"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://swift.im/swift"
else
	SRC_URI="http://swift.im/downloads/releases/${MY_P}/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi
IUSE="avahi debug doc test"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	avahi? ( net-dns/avahi )
	>=dev-libs/boost-1.42
	>=dev-libs/openssl-0.9.8g
	>=net-dns/libidn-1.10
	dev-libs/libxml2
	>=dev-libs/expat-2.0.1
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.75
		>=app-text/docbook-xml-dtd-4.5
		dev-libs/libxslt
	)
"

src_prepare() {
	pushd 3rdParty || die
	# TODO CppUnit, Lua
	rm -rf Boost CAres DocBook Expat LCov LibIDN OpenSSL SCons SQLite ZLib || die
	popd || die
	epatch "${FILESDIR}"/*.patch
}

src_compile() {
	scons_vars=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS}"
		linkflags="${LDFLAGS}"
		allow_warnings=1
		ccache=0
		distcc=1
		$(use_scons debug)
		openssl="${EPREFIX}/usr"
		docbook_xsl="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets"
		docbook_xml="${EPREFIX}/usr/share/sgml/docbook/xml-dtd-4.5"
		swiften_dll=1
		Swiften
	)

	escons "${scons_vars[@]}"
}

src_test() {
	escons "${scons_vars[@]}" test="unit" QA
}

src_install() {
	escons "${scons_vars[@]}" SWIFTEN_INSTALLDIR="${ED}/usr" \
		SWIFTEN_LIBDIR="${ED}/usr/$(get_libdir)" "${ED}/usr"

	use doc && dohtml "Documentation/SwiftenDevelopersGuide/Swiften Developers Guide.html"
}

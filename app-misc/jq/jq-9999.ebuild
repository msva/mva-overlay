# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 patches

DESCRIPTION="Command-line JSON processor"
HOMEPAGE="http://stedolan.github.io/jq/"
EGIT_REPO_URI="https://github.com/stedolan/jq"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="oniguruma static-libs test"

DEPEND="
	>=sys-devel/bison-3.0
	sys-devel/flex
	oniguruma? ( dev-libs/oniguruma[static-libs?] )
	test? ( dev-util/valgrind )
"
RDEPEND="
	!static-libs? (
		oniguruma? ( dev-libs/oniguruma[static-libs?] )
	)
"

EGIT_SUBMODULES=( '*' '-*oniguruma' )

DOCS=( AUTHORS README.md )

src_prepare() {
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	sed -i -r \
		-e "/AC_CONFIG_SUBDIRS\(\[modules\/oniguruma\]\)/d" \
		configure.ac || die
#		-e "1im4_define\([jq_version],[${PV}]\)" \
#		-e "/m4_define\(\[jq_version\],/,+4d" \

	patches_src_prepare
	eautoreconf
}

src_configure() {
	local econfargs=(
		# don't try to rebuild docs
		--disable-docs
		$(use_enable static-libs static)
		$(use_with oniguruma)
	)
	econf "${econfargs[@]}"
}

src_install() {
	default
	use static-libs || (
		find "${D}" -name '*.la' -delete || die
	)
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake lua-single python-single-r1 xdg-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/weechat/weechat.git"
else
	SRC_URI="
		https://weechat.org/files/src/${P}.tar.xz
		verify-sig? ( https://weechat.org/files/src/${P}.tar.xz.asc )
	"
	VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/weechat.org.asc
	BDEPEND+="verify-sig? ( sec-keys/openpgp-keys-weechat )"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
fi

DESCRIPTION="Portable and multi-interface IRC client"
HOMEPAGE="https://weechat.org/"

LICENSE="GPL-3"
SLOT="0/${PV}"

NETWORKS="+irc"
PLUGINS="+alias +buflist +charset +exec +fifo +fset +logger +relay +scripts +spell +trigger +typing +xfer"
INTERFACES="+ncurses +headless"
# dev-lang/v8 was dropped from Gentoo so we can't enable javascript support
SCRIPT_LANGS="guile lua +perl php +python ruby tcl"
LANGS=" cs de es fr hu it ja pl pt pt_BR ru tr"
IUSE="doc enchant man nls selinux test ${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS}"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( headless nls )
"

RDEPEND="
	dev-libs/libgcrypt:0=
	net-libs/gnutls:=
	net-misc/curl[ssl]
	ncurses? ( sys-libs/ncurses:0= )
	sys-libs/zlib
	charset? ( virtual/libiconv )
	guile? ( >=dev-scheme/guile-2.0 )
	lua? ( ${LUA_DEPS} )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	php? ( >=dev-lang/php-7.0:=[embed] )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby )
	selinux? ( sec-policy/selinux-irc )
	spell? (
		enchant? (
			app-text/enchant:0
		)
		!enchant? (
			app-text/aspell
		)
	)
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
"

DEPEND="${RDEPEND}
	test? ( dev-util/cpputest )
"

BDEPEND+="
	virtual/pkgconfig
	doc? ( >=dev-ruby/asciidoctor-1.5.4 )
	man? ( >=dev-ruby/asciidoctor-1.5.4 )
	nls? ( >=sys-devel/gettext-0.15 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-cmake_lua_version.patch
)

DOCS="AUTHORS.adoc ChangeLog.adoc Contributing.adoc ReleaseNotes.adoc README.adoc"

# tests need to be fixed to not use system plugins if weechat is already installed
RESTRICT="!test? ( test )"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# install only required translations
	local i
	for i in ${LANGS} ; do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e "/${i}.po/d" \
				po/CMakeLists.txt || die
		fi
	done

	# install only required documentation ; en always
	for i in $(sed -ne '/set.*_LANG.* en /{s@.*_LANG \([^)]*\))$@\1@;s@en@@g;p}'
		doc/CMakeLists.txt | xargs -n1 | sort -u); do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e '/set[^ ]*_LANG/s@ ${i}@@' \
				doc/CMakeLists.txt || die
		fi
	done

	# install docs in correct directory
	sed -i "s#\${DATAROOTDIR}/doc/\${PROJECT_NAME}#\0-${PVR}/html#" doc/CMakeLists.txt || die

	if [[ ${CHOST} == *-darwin* ]]; then
		# fix linking error on Darwin
		sed -i "s/+ get_config_var('LINKFORSHARED')//" \
			cmake/FindPython.cmake || die
		# allow to find the plugins by default
		sed -i 's/".so,.dll"/".bundle,.so,.dll"/' \
			src/core/wee-config.c || die
	fi

	if use php; then
		sed -i \
			-e '/^install(/iset(CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)' \
			src/plugins/php/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DLIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DENABLE_JAVASCRIPT=OFF
		-DENABLE_LARGEFILE=ON
		-DENABLE_NCURSES=$(usex ncurses)
		-DENABLE_HEADLESS=$(usex headless)
		-DENABLE_ALIAS=$(usex alias)
		-DENABLE_BUFLIST=$(usex buflist)
		-DENABLE_CHARSET=$(usex charset)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_EXEC=$(usex exec)
		-DENABLE_FIFO=$(usex fifo)
		-DENABLE_FSET=$(usex fset)
		-DENABLE_GUILE=$(usex guile)
		-DENABLE_IRC=$(usex irc)
		-DENABLE_LOGGER=$(usex logger)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_MAN=$(usex man)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_PERL=$(usex perl)
		-DENABLE_PHP=$(usex php)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_RELAY=$(usex relay)
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_SCRIPT=$(usex scripts)
		-DENABLE_SCRIPTS=$(usex scripts)
		-DENABLE_SPELL=$(usex spell)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_TCL=$(usex tcl)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TRIGGER=$(usex trigger)
		-DENABLE_TYPING=$(usex typing)
		-DENABLE_XFER=$(usex xfer)
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
	)
	cmake_src_configure
}

src_test() {
	if $(locale -a | grep -iq "en_US\.utf.*8"); then
		cmake_src_test -V
	else
		eerror "en_US.UTF-8 locale is required to run ${PN}'s ${FUNCNAME}"
		die "required locale missing"
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

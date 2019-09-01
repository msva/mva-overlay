# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
CMAKE_MAKEFILE_GENERATOR=emake
inherit python-single-r1 cmake-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/weechat/weechat.git"
else
	SRC_URI="https://weechat.org/files/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Portable and multi-interface IRC client"
HOMEPAGE="https://weechat.org/"

LICENSE="GPL-3"
SLOT="0"

NETWORKS="+irc"
PLUGINS="+alias +buflist +charset +exec +fifo +logger +relay +scripts +spell +trigger +xfer"
INTERFACES="+ncurses headless"
# dev-lang/v8 was dropped from Gentoo so we can't enable javascript support
SCRIPT_LANGS="guile lua luajit +perl php +python ruby tcl"
LANGS=" cs de es fr hu it ja pl pt pt_BR ru tr"
IUSE="doc nls +ssl test ${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS}"
#REQUIRED_USE=" || ( ncurses gtk )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) test? ( headless )"

RDEPEND="
	dev-libs/libgcrypt:0=
	net-misc/curl[ssl]
	ncurses? ( sys-libs/ncurses:0= )
	sys-libs/zlib
	charset? ( virtual/libiconv )
	guile? ( >=dev-scheme/guile-2.0 )
	lua? (
		!luajit? ( || (
			dev-lang/lua:0[deprecated]
			dev-lang/lua:5.1[deprecated]
		) )
		luajit? ( >=dev-lang/luajit-2 )
	)
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	php? ( >=dev-lang/php-7.0:=[embed] )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
"
DEPEND="${RDEPEND}
	doc? (
		>=dev-ruby/asciidoctor-1.5.4
		dev-util/source-highlight
	)
	nls? ( >=sys-devel/gettext-0.15 )
	test? ( dev-util/cpputest )
"

DOCS="AUTHORS.adoc ChangeLog.adoc Contributing.adoc ReleaseNotes.adoc README.adoc"

# tests need to be fixed to not use system plugins if weechat is already installed
RESTRICT="test"

#PATCHES=( "${FILESDIR}"/${PN}-1.2-tinfo.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	use ruby && (
		sed -i \
			-e 's@\(pkg_search_module(RUBY\) \(.*\)@\1 ruby-2.5 ruby-2.4 ruby \2@' \
			cmake/FindRuby.cmake
	)

	use luajit && (
		sed -i \
			-e 's@\(pkg_search_module(LUA\) \(.*\)@\1 luajit-2.1 luajit-2.0 luajit \2@' \
			cmake/FindLua.cmake
	)

	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		CMakeLists.txt || die "sed failed"

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
	for i in $(grep add_subdirectory doc/CMakeLists.txt \
			| sed -e 's/.*add_subdirectory(\(..\)).*/\1/' -e '/en/d'); do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e '/add_subdirectory('${i}')/d' \
				doc/CMakeLists.txt || die
		fi
	done

	# install docs in correct directory
	sed -i "s#\${SHAREDIR}/doc/\${PROJECT_NAME}#\0-${PV}/html#" doc/*/CMakeLists.txt || die

	if [[ ${CHOST} == *-darwin* ]]; then
		# fix linking error on Darwin
		sed -i "s/+ get_config_var('LINKFORSHARED')//" \
			cmake/FindPython.cmake || die
		# allow to find the plugins by default
		sed -i 's/".so,.dll"/".bundle,.so,.dll"/' \
			src/core/wee-config.c || die
	fi
}

src_configure() {
	local needlua=$( (use lua || use luajit) && echo "yes" || echo "no");

	local mycmakeargs=(
		-DENABLE_NCURSES=$(usex ncurses)
		-DENABLE_HEADLESS=$(usex headless)
		-DENABLE_LARGEFILE=ON
		-DENABLE_JAVASCRIPT=OFF
		-DENABLE_ALIAS=$(usex alias)
		-DENABLE_BUFLIST=$(usex buflist)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_CHARSET=$(usex charset)
		-DENABLE_EXEC=$(usex exec)
		-DENABLE_FIFO=$(usex fifo)
		-DENABLE_GUILE=$(usex guile)
		-DENABLE_IRC=$(usex irc)
		-DENABLE_LOGGER=$(usex logger)
		-DENABLE_LUA="${needlua}"
		-DENABLE_NLS=$(usex nls)
		-DENABLE_PERL=$(usex perl)
		-DENABLE_PHP=$(usex php)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_RELAY=$(usex relay)
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_SCRIPTS=$(usex scripts)
		-DENABLE_SCRIPT=$(usex scripts)
		-DENABLE_ASPELL=$(usex spell)
		-DENABLE_GNUTLS=$(usex ssl)
		-DENABLE_TCL=$(usex tcl)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_TRIGGER=$(usex trigger)
		-DENABLE_XFER=$(usex xfer)
	)

	if use python; then
		python_export PYTHON_LIBPATH
		mycmakeargs+=(
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_LIBRARY="${PYTHON_LIBPATH}"
		)
		[[ ${EPYTHON} == python3* ]] && mycmakeargs+=( -DENABLE_PYTHON3=yes )
	fi

	cmake-utils_src_configure
}

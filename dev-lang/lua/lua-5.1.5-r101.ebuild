# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib multilib-minimal portability toolchain-funcs patches

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="+deprecated emacs readline +static"

RDEPEND="
	readline? ( >=sys-libs/readline-6.3:0[${MULTILIB_USEDEP}] )
	app-eselect/eselect-lua
	!dev-lang/lua:0
"
DEPEND="${RDEPEND}
	sys-devel/libtool"
PDEPEND="emacs? ( app-emacs/lua-mode )"

SAN_SLOT="${SLOT//.}"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/lua${SLOT}/luaconf.h"
)

src_prepare() {
	patches_src_prepare

	# correct lua versioning
	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\16:5:1/' src/Makefile

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	# custom Makefiles
	multilib_copy_sources

	cp "${FILESDIR}/lua.pc" "${S}"
	# A slotted Lua uses different directories for headers & names for
	# libraries, and pkgconfig should reflect that.
	sed -r -i \
		-e "s:^V=.*:V= ${SLOT}:" \
		-e "s:^R=.*:R= ${PV}:" \
		-e "s:/,lib,:/$(get_libdir):g" \
		-e "/^Libs:/s,((-llua)($| )),\2${SLOT}\3," \
		"${S}"/lua.pc
}

multilib_src_configure() {
	# We want packages to find our things...
	sed -i \
		-e 's:/usr/local:'${EPREFIX}'/usr:' \
		-e "s:\([/\"]\)\<lib\>:\1$(get_libdir):g" \
		etc/lua.pc src/luaconf.h || die
}

multilib_src_compile() {
	tc-export CC
	myflags=
	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CC="${CC}" CFLAGS="-DLUA_USE_LINUX ${CFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			gentoo_all

	mv lua_test ../test/lua.static
}

multilib_src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins "${S}/lua.pc" "lua${SLOT}.pc"
}

multilib_src_install_all() {
	DOCS=(HISTORY README)
	HTML_DOCS=(doc/*.html doc/*.png doc/*.css doc/*.gif)
	einstalldocs

	doicon etc/lua.ico

	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
}

multilib_src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${BUILD_DIR}" || die
	for test in ${positive}; do
		test/lua.static test/${test}.lua || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua && die "test $test failed"
	done
}

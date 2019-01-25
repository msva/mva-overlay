# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils autotools multilib multilib-minimal portability toolchain-funcs patches

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated emacs readline +static"

RDEPEND="
	readline? ( >=sys-libs/readline-6.3:0[${MULTILIB_USEDEP}] )
	app-eselect/eselect-lua
	!dev-lang/lua:0
"
DEPEND="${RDEPEND}
	sys-devel/libtool"
PDEPEND="emacs? ( app-emacs/lua-mode )"

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/lua${SLOT}/luaconf.h"
)

src_prepare() {
	patches_src_prepare

	# use glibtool on Darwin (versus Apple libtool)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/LIBTOOL = /s:/libtool:/glibtool:' \
			Makefile src/Makefile || die
	fi

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html || die

	if ! use readline ; then
		sed -i -e '/#define LUA_USE_READLINE/d' src/luaconf.h || die
	fi

	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\10:0:0/' src/Makefile || die

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries (both shared and static
	# are installed)
	if use static ; then
		sed -i -e 's:\(-export-dynamic\):-static \1:' src/Makefile || die
	fi

	# upstream does not use libtool, but we do (see bug #336167)
	cp "${FILESDIR}/configure.ac" "${S}"/ || die
	eautoreconf

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
	sed -i \
		-e 's:\(define LUA_ROOT\s*\).*:\1"'${EPREFIX}'/usr/":' \
		-e "s:\(define LUA_CDIR\s*LUA_ROOT \"\)lib:\1$(get_libdir):" \
		src/luaconf.h \
	|| die "failed patching luaconf.h"

	econf
}

multilib_src_compile() {
	tc-export CC

	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	use readline && mylibs="-lreadline"

	cd src

	local myCFLAGS;
	use deprecated && myCFLAGS="-DLUA_COMPAT_5_2 -DLUA_COMPAT_5_1 -DLUA_COMPAT_ALL"
# -DLUA_COMPAT_FLOATSTRING"

	case "${CHOST}" in
		*-mingw*) : ;;
		*) myCFLAGS+=" -DLUA_USE_LINUX" ;;
	esac

	emake CC="${CC}" CFLAGS="${myCFLAGS} ${CFLAGS}" \
			SYSLDFLAGS="${LDFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=${SLOT} \
			gentoo_all
}

multilib_src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins "${S}/lua.pc" "lua${SLOT}.pc"
}

multilib_src_install_all() {
	DOCS=(README)
	HTML_DOCS=(doc/*.html doc/*.png doc/*.css doc/*.gif)
	einstalldocs

	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
}

# Makefile contains a dummy target that doesn't do tests
# but causes issues with slotted lua (bug #510360)
src_test() { :; }

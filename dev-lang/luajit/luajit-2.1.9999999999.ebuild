# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit multilib-minimal pax-utils toolchain-funcs check-reqs git-r3 patches

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://luajit.org/"
EGIT_REPO_URI="https://luajit.org/git/luajit-2.0.git"
EGIT_BRANCH="v2.1"
EGIT_MIN_CLONE_TYPE="single+tags"

LICENSE="MIT"
SLOT="2"
IUSE="debug valgrind lua52compat openresty +optimization static-libs"

RDEPEND="
	valgrind? ( dev-debug/valgrind )
"
DEPEND="
	${RDEPEND}
	app-eselect/eselect-luajit
	app-eselect/eselect-lua
"

HTML_DOCS=( "doc/." )

MULTILIB_WRAPPED_HEADERS=(
	"/usr/include/luajit-${SLOT}/luaconf.h"
)

check_req() {
	if use optimization; then
		CHECKREQS_MEMORY="300M"
		check-reqs_pkg_${1}
	fi
}

pkg_pretend() {
	check_req pretend
}

pkg_setup() {
	check_req setup
}

src_unpack() {
	if use openresty; then
		EGIT_REPO_URI="https://github.com/openresty/luajit2"
		EGIT_BRANCH="v2.1-agentzh"
	fi
	git-r3_src_unpack
}

src_prepare() {
	patches_src_prepare

	use openresty && (
		sed -r \
			-e '/\$\(SYMLINK\) \$\(INSTALL_TNAME\) \$\(INSTALL_TSYM\)/d' \
			-i Makefile
	)

	# fixing prefix and version
	sed -r \
		-e 's|^(VERSION)=.*|\1=${PV}|' \
		-e 's|^(INSTALL_SONAME)=.*|\1=$(INSTALL_SOSHORT1).$(VERSION)|' \
		-e 's|^(INSTALL_PCNAME)=.*|\1=${P}.pc|' \
		-e 's|( PREFIX)=.*|\1=/usr|' \
		-e 's|^(FILE_MAN)=.*|\1=${P}.1|' \
		-i Makefile || die "failed to fix prefix in Makefile"

	sed -r \
		-e 's|^(#define LUA_LJDIR).*|\1 "/'${P}'/"|' \
		-i src/luaconf.h || die "Failed to slotify"

	use debug && (
		sed -r \
			-e 's/#(CCDEBUG= -g)/\1 -O0/' \
			-i src/Makefile || die "Failed to enable debug"
	)
	mv "${S}"/etc/${PN}.1 "${S}"/etc/${P}.1

	multilib_copy_sources
}

multilib_src_configure() {
	sed -r \
		-e "s|^(prefix)=.*|\1=${EROOT:-/}usr|" \
		-e "s|^(multilib)=.*|\1=$(get_libdir)|" \
		-i "etc/${PN}.pc" || die "Failed to slottify"
}

multilib_src_compile() {
	local opt xcflags;
	use optimization && opt="amalg";

	tc-export CC

	xcflags=(
		$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")
		$(usex debug "-DLUAJIT_USE_GDBJIT" "")
		$(usex valgrind "-DLUAJIT_USE_VALGRIND" "")
		$(usex valgrind "-DLUAJIT_USE_SYSMALLOC" "")
		$(usex amd64 "-DLUAJIT_ENABLE_GC64" "")
#		$(usex arm64 "-DLUAJIT_ENABLE_GC64" "")
#		$(usex mips64 "-DLUAJIT_ENABLE_GC64" "")
#		$(usex ppc64 "-DLUAJIT_ENABLE_GC64" "")
#		$(usex s390_64 "-DLUAJIT_ENABLE_GC64" "")
	)

	emake \
		Q= \
		HOST_CC="$(tc-getCC)" \
		CC="${CC}" \
		TARGET_STRIP="true" \
		MULTILIB="$(get_libdir)" \
		LMULTILIB="$(get_libdir)" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		XCFLAGS="${xcflags[*]} -fPIC" ${opt}
}

multilib_src_install() {
	emake DESTDIR="${D}" MULTILIB="$(get_libdir)" LMULTILIB="$(get_libdir)" install

	einstalldocs

	host-is-pax && pax-mark m "${D}/usr/bin/${P}"
	newman "etc/${P}.1" "luacjit-${PV}.1"
	newbin "${FILESDIR}/luac.jit" "luacjit-${PV}"
	ln -fs "${P}" "${D}/usr/bin/${PN}-${SLOT}"
}

pkg_postinst() {
	if [[ ! -n $(readlink "${EROOT:-/}"usr/bin/luajit) ]] ; then
		eselect luajit set luajit-${PV}
	fi
	if [[ ! -n $(readlink "${EROOT:-/}"usr/bin/lua) ]] ; then
		eselect lua set jit-${PV}
	fi
}

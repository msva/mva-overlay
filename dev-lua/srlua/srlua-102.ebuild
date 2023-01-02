# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua toolchain-funcs

DESCRIPTION="A simple tool, that help you to glue lua script with interpreter"
HOMEPAGE="https://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/index.html#srlua"
SRC_URI="https://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/ar/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="+static-libs"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

each_lua_test() {
	pushd "${BUILD_DIR}"
	emake test.lua
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	local m_abi="${CHOST%%-*}"
	exeinto "/usr/libexec/${PN}/${ELUA}.${m_abi}"
	doexe "${PN}" glue
	popd
}

my_cc() {
	local cc=$(tc-getCC)
	einfo ${cc} ${*}
	${cc} ${*} || die
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	local STATIC
	use static-libs && STATIC="-static"
	my_cc ${CFLAGS} ${LDFLAGS} -fPIC -o glue srglue.c
	my_cc ${CFLAGS} ${LDFLAGS} -fPIC -o srlua srlua.c -Wl,-E ${STATIC} $(lua_get_LIBS) -ldl -lm
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin "${FILESDIR}"/glue
	einstalldocs
}

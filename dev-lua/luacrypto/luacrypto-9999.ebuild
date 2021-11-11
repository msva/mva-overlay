# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LANGS=(en ru)

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"
EGIT_REPO_URI="https://github.com/msva/lua-crypto"

LICENSE="MIT"
SLOT="0"
IUSE="doc +openssl gcrypt l10n_en l10n_ru"
REQUIRED_USE="${LUA_REQUIRED_USE} ^^ ( openssl gcrypt )"
RDEPEND="
	${LUA_DEPS}
	openssl? ( >=dev-libs/openssl-0.9.7 )
	gcrypt? ( dev-libs/libgcrypt )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	for x in ${LANGS[@]}; do
		if use l10n_${x}; then
			HTML_DOCS+=( doc/${x} )
		fi
	done
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	local engine="openssl";
	if use gcrypt; then
		engine="gcrypt"
		tc-getPROG GCRYPT_CONFIG libgcrypt-config
	fi

	emake \
		LUA_IMPL="${ELUA}" \
		CRYPTO_ENGINE="${engine}" \
		GCRYPT_CONFIG="${GCRYPT_CONFIG}"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins src/crypto.so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}

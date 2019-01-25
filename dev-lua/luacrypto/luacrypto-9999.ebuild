# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LANGS=(en ru)

VCS="git"
IS_MULTILIB=true
GITHUB_A="msva"
GITHUB_PN="lua-crypto"
inherit lua

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +openssl gcrypt l10n_en l10n_ru"

RDEPEND="
	openssl? ( >=dev-libs/openssl-0.9.7 )
	gcrypt? ( dev-libs/libgcrypt )
"

REQUIRED_USE="^^ ( openssl gcrypt )"

DOCS=(README)
HTML_DOCS=()

all_lua_prepare() {
	for x in ${LANGS[@]}; do
		if use l10n_${x}; then
			HTML_DOCS+=( doc/${x} )
		fi
	done
	lua_default
}

each_lua_compile() {
	local engine="openssl";
	if use gcrypt; then
		engine="gcrypt"
		tc-getPROG GCRYPT_CONFIG libgcrypt-config
	fi

	lua_default \
		LUA_IMPL="${lua_impl}" \
		CRYPTO_ENGINE="${engine}" \
		GCRYPT_CONFIG="${GCRYPT_CONFIG}"
}

each_lua_install() {
	dolua src/crypto.so
}

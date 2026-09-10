# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo multiprocessing

DESCRIPTION="Rust library for drawing Lottie animations"
HOMEPAGE="https://dkaraush.github.io/tlottie"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3 cargo
	EGIT_REPO_URI="https://github.com/dkaraush/tlottie"
else
	CRATES="
		cfg-if@1.0.4
		dlmalloc@0.2.14
		foldhash@0.1.5
		hashbrown@0.15.5
		libc@0.2.189
		windows-link@0.2.1
		windows-sys@0.61.2
	"
	inherit cargo
	MY_SHA=4b940c7942fbde8ee56f10f39a5224a4153bd91e
	S="${WORKDIR}/${PN}-${MY_SHA:-${PV}}"
	SRC_URI="https://github.com/dkaraush/tlottie/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" ${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64"
	# TODO: others
fi

LICENSE="MIT"
# SLOT="0/${PV%_pre.*}"
SLOT="0"
IUSE="${IUSE} static-libs"

BDEPEND="dev-util/cargo-c"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default

	# cargo-c compatibility
	sed -r \
		-e 's@c-api@capi@' \
		-i Cargo.toml src/bindings/mod.rs src/lib.rs || die

	if ! [[ ${PV} == 9999 ]]; then
		cargo_update_crates
	fi
}

src_configure() {
	# local cargoargs=(
	# 	--features c-api
	# 	# --features capi
	# 	--lib
	# 	--crate-type cdylib,staticlib
	# 	# --crate-type staticlib
	# 	--jobs $(get_makeopts_jobs)
	# 	$(usev !debug "--release")
	# )
	common_cargoargs=(
		--features capi
		--lib
		--jobs $(get_makeopts_jobs)
		$(usev static-libs "--crt-static")
		$(usev !static-libs "--library-type=cdylib")
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		--destdir="${D}"
		--prefix="${EPREFIX}"/usr
		# NOTE: 👇 doesn't work (maybe only with rust-bin 🤷)
		# --no-default-features
		# --features=no-std
	)
}

src_compile() {
	# NOTE: Currently upstream recommends this for build, but it doesn't install anything

	# edo cargo rustc "${cargoargs[@]}" || die "cargo rustc build failed"

	# FIXME: cbuild/cinstall makes tlottie.h with duplicating declarations somewhy

	local cargoargs=(
		${common_cargoargs[@]}
		$(usev !debug "--release")
	)
	edo cargo cbuild "${cargoargs[@]}" || die "cargo cbuild failed"
}

src_install() {
	# FIXME: cbuild/cinstall makes tlottie.h with duplicating declarations somewhy

	local cargoargs=(
		${common_cargoargs[@]}
		$(usex debug '--debug' '--release')
	)
	edo cargo cinstall "${cargoargs[@]}" || die "cargo cinstall failed"

	# HACK:
	insinto /usr/include/tlottie
	doins include/tlottie.h
}

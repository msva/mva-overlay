# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit patches toolchain-funcs

DESCRIPTION="The password hash Argon2, winner of PHC"
HOMEPAGE="https://github.com/P-H-C/phc-winner-argon2"
EGIT_REPO_URI="https://github.com/P-H-C/phc-winner-argon2"
if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
else
	SRC_URI="${EGIT_REPO_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/phc-winner-${P}"
fi
LICENSE="|| ( Apache-2.0 CC0-1.0 )"
SLOT="0/1"
IUSE="static-libs"

DOCS=("README.md" "CHANGELOG.md" "${PN}-specs.pdf")

src_prepare() {
	default
	if ! use static-libs; then
		sed -i -e '/LIBRARIES =/s/\$(LIB_ST)//' Makefile || die "sed failed!"
	fi
	sed \
		-e 's/-O3 //' \
		-e 's/-g //' \
		-e "s/-march=\$(OPTTARGET)//" \
		-e "/^LIBRARY_REL/s@LIBRARY_REL.*@LIBRARY_REL = $(get_libdir)@" \
		-i Makefile || die "sed failed"

	tc-export CC

	OPTTEST=1
	if use amd64 || use x86; then
		$(tc-getCPP) ${CFLAGS} ${CPPFLAGS} -P - <<-EOF &>/dev/null && OPTTEST=0
			#if defined(__SSE2__)
			true
			#else
			#error false
			#endif
		EOF
	fi
}

src_compile() {
	emake OPTTEST="${OPTTEST}" LIBRARY_REL="$(get_libdir)" PREFIX="${EPREFIX}/usr" \
		ARGON2_VERSION="0~${PV}"
}

src_test() {
	emake OPTTEST="${OPTTEST}" test
}

src_install() {
	emake OPTTEST="${OPTTEST}" DESTDIR="${ED}" LIBRARY_REL="$(get_libdir)" install
	einstalldocs
	doman man/argon2.1
}

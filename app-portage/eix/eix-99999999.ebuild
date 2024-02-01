# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_LIBTOOL=none
AUTOTOOLS_AUTO_DEPEND=no
MESON_AUTO_DEPEND=no

inherit autotools bash-completion-r1 meson ninja-utils tmpfiles

if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vaeth/${PN}.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	RESTRICT="mirror"
	EGIT_COMMIT="470c9d35ed91bfac3f808c5e8625c61a04234b8f"
	SRC_URI="https://github.com/vaeth/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Search and query ebuilds"
HOMEPAGE="https://github.com/vaeth/eix/"

LICENSE="GPL-2"
SLOT="0"
PLOCALES="de ru"
IUSE="debug +dep doc +jumbo-build"
for i in ${PLOCALES}; do
	IUSE+=" l10n_${i}"
done
IUSE+=" +meson nls optimization +required-use security +src-uri strong-optimization strong-security sqlite swap-remote tools"

BOTHDEPEND="
	nls? ( virtual/libintl )
	sqlite? ( >=dev-db/sqlite-3:= )
"
RDEPEND="
	${BOTHDEPEND}
	>=app-shells/push-3.1
	>=app-shells/quoter-4.1
"
BDEPEND="
	${BOTHDEPEND}
	nls? ( sys-devel/gettext )
	meson? (
		>=dev-build/meson
		${NINJA_DEPEND}
		strong-optimization? ( >=sys-devel/gcc-config-1.9.1 )
	)
	!meson? ( ${AUTOTOOLS_DEPEND} )
"

pkg_setup() {
	# remove stale cache file to prevent collisions
	local old_cache="${EROOT}/var/cache/${PN}"
	test -f "${old_cache}" && rm -f -- "${old_cache}"
}

src_prepare() {
	sed -i -e "s'/'${EPREFIX}/'" -- "${S}"/tmpfiles.d/eix.conf || die
	default
	use meson || {
		eautopoint
		eautoreconf
	}
}

src_configure() {
	local i
	export LINGUAS=
	for i in ${PLOCALES}; do
		use l10n_${i} && LINGUAS+=${LINGUAS:+ }${i}
	done
	if use meson; then
		local emesonargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${P}"
		-Dhtmldir="${EPREFIX}/usr/share/doc/${P}/html"
		$(meson_use jumbo-build)
		$(meson_use sqlite)
		$(meson_use doc extra-doc)
		$(meson_use nls)
		$(meson_use tools separate-tools)
		$(meson_use security)
		$(meson_use optimization normal-optimization)
		$(meson_use strong-security)
		$(meson_use strong-optimization)
		$(meson_use debug debugging)
		$(meson_use swap-remote)
		$(meson_use prefix always-accept-keywords)
		$(meson_use dep dep-default)
		$(meson_use required-use required-use-default)
		$(meson_use src-uri src-uri-default)
		-Dzsh-completion="${EPREFIX}/usr/share/zsh/site-functions"
		-Dportage-rootpath="${ROOTPATH}"
		-Deprefix-default="${EPREFIX}"
		)
		if use prefix; then
			emesonarge+=(
				-Deix-user=
				-Deix-uid=-1
			)
		fi
		meson_src_configure
	else
		local myconf=(
		$(use_enable jumbo-build)
		$(use_with sqlite)
		$(use_with doc extra-doc)
		$(use_enable nls)
		$(use_enable tools separate-tools)
		$(use_enable security)
		$(use_enable optimization)
		$(use_enable strong-security)
		$(use_enable strong-optimization)
		$(use_enable debug debugging)
		$(use_enable swap-remote)
		$(use_with prefix always-accept-keywords)
		$(use_with dep dep-default)
		$(use_with required-use required-use-default)
		$(use_with src-uri src-uri-default)
		--with-zsh-completion
		--with-portage-rootpath="${ROOTPATH}"
		--with-eprefix-default="${EPREFIX}"
		)
		if use prefix; then
			myconf+=(
				--with-eix-user=
				--with-eix-uid=-1
			)
		fi
		econf "${myconf[@]}"
	fi
}

src_compile() {
	if use meson; then
		meson_src_compile
	else
		default
	fi
}

src_test() {
	if use meson; then
		meson_src_test
	else
		default
	fi
}

src_install() {
	if use meson; then
		meson_src_install
	else
		default
	fi
	dobashcomp bash/eix
	dotmpfiles tmpfiles.d/eix.conf
}

pkg_postinst() {
	local obs="${EROOT}/var/cache/eix.previous"
	if test -f "${obs}"; then
		ewarn "Found obsolete ${obs}, please remove it"
	fi
	tmpfiles_process eix.conf
}

pkg_postrm() {
	if [ -z "${REPLACED_BY_VERSION}" ]; then
		rm -rf -- "${EROOT}/var/cache/${PN}"
	fi
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils eutils patches multilib-minimal git-r3

MY_PN="LibVNCServer"

DESCRIPTION="library for creating vnc servers"
HOMEPAGE="https://libvnc.github.io/"
EGIT_REPO_URI="https://github.com/LibVNC/${PN}"

LICENSE="GPL-2"
# No sub slot wanted (yet), see #578958
SLOT="0"
KEYWORDS=""
IUSE="+24bpp examples +filetransfer ffmpeg gcrypt gnutls ipv6 +jpeg libressl +png sasl sdl ssl systemd test +threads websockets X +zlib"
REQUIRED_USE="!gnutls? ( ssl? ( threads ) )"

DEPEND="
	sasl? ( dev-libs/cyrus-sasl:2= )
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}] )
	gnutls? (
		>=net-libs/gnutls-2.12.23-r6:0=[${MULTILIB_USEDEP}]
		>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		ssl? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		)
	)
	examples? (
		ffmpeg? ( >=media-video/ffmpeg-3.1:= )
		sdl? ( media-libs/libsdl:0= )
		X? ( x11-libs/libX11:0= )
	)
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:= )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:0=[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

multilib_src_configure() {
	mycmakeargs=(
		-DWITH_ZLIB=$(usex zlib ON OFF)
		-DWITH_JPEG=$(usex jpeg ON OFF)
		-DWITH_PNG=$(usex png ON OFF)
		-DWITH_SDL=$(usex sdl ON OFF)
		-DWITH_X11=$(usex X ON OFF)
		-DWITH_THREADS=$(usex threads ON OFF)
		-DWITH_GNUTLS=$(usex gnutls ON OFF)
		-DWITH_OPENSSL=$(usex gnutls OFF $(usex ssl ON OFF))
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
		-DWITH_GCRYPT=$(usex gnutls ON $(usex gcrypt ON OFF))
		-DWITH_FFMPEG=$(usex ffmpeg ON OFF)
		-DWITH_TIGHTVNC_FILETRANSFER=$(usex filetransfer ON OFF)
		-DWITH_24BPP=$(usex 24bpp ON OFF)
		-DWITH_IPv6=$(usex ipv6 ON OFF)
		-DWITH_WEBSOCKETS=$(usex websockets on off)
		-DWITH_SASL=$(usex sasl ON OFF)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	if use examples && multilib_is_native_abi; then
		for e in examples/* client_examples/*; do
			local vnc="" be="$(basename ${e})"
			if [[ "${e,,}" =~ vnc ]]; then
				dobin "${e}"
			else
				vnc="vnc-"
				newbin "${e}" "${vnc}${be}"
			fi
			TMPDIR="${PORTAGE_BUILDDIR}" scanelf -BXr "${ED}/usr/bin/${vnc}${be}" -o /dev/null # QA: fixing rpath
		done
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}

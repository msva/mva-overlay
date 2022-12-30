# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson-multilib vala

DESCRIPTION="VIPS Image Processing Library"
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lib${PN}/lib${PN}"
else
	SRC_URI="https://github.com/lib${PN}/lib${PN}/archive/v${PV//_rc/-rc}.tar.gz -> lib${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
HOMEPAGE="https://libvips.github.io/libvips/"

LICENSE="LGPL-2.1"
SLOT="0"

VIPS_BASE_OPTS="debug +deprecated doxygen gtk-doc +introspection vala pandoc"
VIPS_EXT_LIBS="cgif cfitsio exif fftw fontconfig gsf heif nifti imagequant jpeg jpeg-xl lcms imagemagick graphicsmagick matio openexr openjpeg openslide orc pangocairo png poppler rsvg spng tiff webp zlib"
# pdfium quantizr
VIPS_INT_LIBS="+nsgif +ppm +analyze +radiance"

IUSE="${VIPS_BASE_OPTS} ${VIPS_EXT_LIBS} ${VIPS_INT_LIBS}"

RDEPEND="
	>=dev-libs/glib-2.6:2
	introspection? ( dev-libs/gobject-introspection )
	cfitsio? ( sci-libs/cfitsio[${MULTILIB_USEDEP}] )
	cgif? ( media-libs/cgif[${MULTILIB_USEDEP}] )
	exif? ( >=media-libs/libexif-0.6[${MULTILIB_USEDEP}] )
	fftw? ( sci-libs/fftw:3.0=[${MULTILIB_USEDEP}] )
	gsf? ( gnome-extra/libgsf )
	heif? ( media-libs/libheif[${MULTILIB_USEDEP}] )
	imagequant? ( media-gfx/libimagequant )
	nifti? ( media-libs/nifti[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}] )
	jpeg-xl? ( media-libs/libjxl[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms[${MULTILIB_USEDEP}] )
	imagemagick? ( media-gfx/imagemagick )
	graphicsmagick? ( media-gfx/graphicsmagick )
	matio? ( >=sci-libs/matio-1.3.4 )
	openexr? ( >=media-libs/openexr-1.2.2 )
	openjpeg? ( media-libs/openjpeg[${MULTILIB_USEDEP}] )
	openslide? ( media-libs/openslide )
	orc? ( >=dev-lang/orc-0.4.11[${MULTILIB_USEDEP}] )
	pangocairo? (
		>=x11-libs/pango-1.8[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	png? ( >=media-libs/libpng-1.2.9:0=[${MULTILIB_USEDEP}] )
	poppler? ( app-text/poppler )
	spng? ( media-libs/libspng[${MULTILIB_USEDEP}] )
	rsvg? ( gnome-base/librsvg[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	vala? ( $(vala_depend) )
"
BDEPEND="
	${RDEPEND}
	gtk-doc? (
		dev-util/gtk-doc-am
		dev-util/gtk-doc
		pandoc? ( virtual/pandoc )
	)
	doxygen? (
		app-doc/doxygen
	)
"

REQUIRED_USE="graphicsmagick? ( !imagemagick )"

DOCS=(ChangeLog README.md)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/vips/version.h
)

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local magic="disabled"
	local magickpkg
	# TODO: port imagemagick to multilib, so it can be linked on non-native multilib ABIs too
	if use imagemagick; then
		magickpgk="MagickCore"
		magick=$(meson_native_use_feature imagemagick magick)
	elif use graphicsmagick; then
		magickpkg="GraphicsMagick"
		magick=$(meson_native_use_feature graphicsmagick magick)
	fi

	# TODO: maybe, port to for-loops?
	local emesonargs=(
		# Base options
		$(meson_use debug)
		$(meson_use deprecated)
		$(meson_native_use_bool doxygen)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool introspection)
		$(meson_use vala vapi)
		-Dmodules=enabled

		# External libs
		# N.B.: TODO: port libs with meson_*_native in this block to multilib.
		$(meson_feature cfitsio)
		$(meson_feature cgif)
		$(meson_feature exif)
		$(meson_feature fftw)
		$(meson_feature fontconfig)
		$(meson_native_use_feature gsf)
		$(meson_feature heif)
		$(meson_feature heif heif-module)
		$(meson_native_use_feature imagequant)
		$(meson_feature jpeg)
		$(meson_feature jpeg-xl)
		$(meson_feature jpeg-xl jpeg-xl-module)
		$(meson_feature lcms)
		${magick}
		${magick//=/-module=}
		-Dmagick-package="${magickpkg}"
		# -Dmagick-features="[load,save]"
		$(meson_native_use_feature matio)
		$(meson_feature nifti)
		$(usex nifti '-Dnifti-prefix-dir=/usr' '')
		$(meson_native_use_feature openexr) # v2 - have multilib, v3 - don't 🤷; TODO: ask maintainer why?
		$(meson_feature openjpeg)
		$(meson_native_use_feature openslide)
		$(meson_native_use_feature openslide openslide-module)
		$(meson_feature orc)
		$(meson_feature pangocairo)
		# $(meson_feature pdfium)
		-Dpdfium=disabled # fucking google "gn" buildsystem. I don't wan't to fuck with that to package pdfium, sorry.
		$(meson_feature png)
		$(meson_native_use_feature poppler)
		$(meson_native_use_feature poppler poppler-module)
		# $(meson_feature quantizr)
		-Dquantizr=disabled # I've failed to find what is that lib at all 🤷; TODO: mutual exclusive with imagequant
		$(meson_feature rsvg)
		$(meson_feature spng)
		$(meson_feature tiff)
		$(meson_feature webp)
		$(meson_feature zlib)

		# Internal libs
		$(meson_use nsgif)
		$(meson_use ppm)
		$(meson_use analyze)
		$(meson_use radiance)
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -xtype f -name '*.la' -print0
}

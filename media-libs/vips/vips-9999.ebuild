# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
inherit flag-o-matic meson-multilib python-single-r1 toolchain-funcs vala

DESCRIPTION="VIPS Image Processing Library"
HOMEPAGE="https://www.libvips.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lib${PN}/lib${PN}"
else
	SRC_URI="https://github.com/lib${PN}/lib${PN}/archive/v${PV//_rc/-rc}.tar.gz -> ${P}.tar.gz"
fi

[[ "${PV}" == 9999 ]] || KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1+ MIT"
SLOT="0/42" # soname

VIPS_BASE_OPTS="debug +deprecated doc cpp-docs +introspection pandoc python test vala"
VIPS_EXT_LIBS="
	archive cgif exif fftw fits fontconfig graphicsmagick heif +highway
	nifti imagemagick imagequant +jpeg jpeg2k jpegxl lcms matio openexr
	openslide orc pango pdf +png svg spng tiff webp
"
# pdfium quantizr
VIPS_INT_LIBS="+nsgif +ppm +analyze +radiance"

IUSE="${VIPS_BASE_OPTS} ${VIPS_EXT_LIBS} ${VIPS_INT_LIBS}"

RDEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	virtual/libintl
	archive? ( app-arch/libarchive:= )
	cgif? ( media-libs/cgif[${MULTILIB_USEDEP}] )
	exif? ( media-libs/libexif[${MULTILIB_USEDEP}] )
	fftw? ( sci-libs/fftw:3.0=[${MULTILIB_USEDEP}] )
	fits? ( sci-libs/cfitsio:=[${MULTILIB_USEDEP}] )
	fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	heif? ( media-libs/libheif:=[${MULTILIB_USEDEP}] )
	highway? ( >=dev-cpp/highway-1.0.5[${MULTILIB_USEDEP}] )
	!highway? (
		orc? ( dev-lang/orc[${MULTILIB_USEDEP}] )
	)
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:= )
		graphicsmagick? ( media-gfx/graphicsmagick:= )
	)
	imagequant? ( media-gfx/libimagequant )
	introspection? ( dev-libs/gobject-introspection )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl[${MULTILIB_USEDEP}] )
	lcms? ( media-libs/lcms:2[${MULTILIB_USEDEP}] )
	matio? ( sci-libs/matio:= )
	nifti? ( media-libs/nifti[${MULTILIB_USEDEP}] )
	openexr? ( media-libs/openexr:= )
	openslide? ( media-libs/openslide )
	pango? (
		>=x11-libs/pango-1.8[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	pdf? (
		app-text/poppler[cairo]
		x11-libs/cairo
	)
	png? ( media-libs/libpng:=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	)
	spng? ( media-libs/libspng[${MULTILIB_USEDEP}] )
	svg? (
		gnome-base/librsvg:2[${MULTILIB_USEDEP}]
		virtual/zlib:=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
	)
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp[${MULTILIB_USEDEP}] )
"
	# gsf? ( gnome-extra/libgsf )
DEPEND="
	${RDEPEND}
	pango? ( x11-base/xorg-proto )
	pdf? ( x11-base/xorg-proto )
	svg? ( x11-base/xorg-proto )
	test? (
		tiff? ( media-libs/tiff[jpeg] )
	)
	sci-libs/hdf5
"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	cpp-docs? (
		app-text/doxygen
	)
	doc? (
		dev-util/gi-docgen
	)
	python? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )
"
# doc? media-gfx/graphviz

REQUIRED_USE="
	fontconfig? ( pango )
	graphicsmagick? ( imagemagick )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( jpeg png webp )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

DOCS=(ChangeLog README.md)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/vips/version.h
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	use vala && vala_setup

	sed -i "s/'vips-doc'/'${PF}'/" cplusplus/meson.build || die

	sed -i "/subdir('fuzz')/d" meson.build || die
}

multilib_src_configure() {
	# workaround for bug in lld (bug #921728)
	tc-ld-is-lld && filter-lto

	local emesonargs=(
		# Base options
		$(meson_use debug)
		$(meson_use deprecated)
		$(meson_native_use_bool doc docs)
		-Dexamples=false
		$(meson_native_use_bool cpp-docs cpp-docs)
		$(meson_use vala vapi)
		-Dmodules=enabled

		# External libs
		# N.B.: TODO: port libs with meson_*_native in this block to multilib.
		$(meson_feature archive)
		$(meson_feature cgif)
		$(meson_feature exif)
		$(meson_feature fftw)
		$(meson_feature fits cfitsio)
		$(meson_feature fontconfig)
		# $(meson_native_use_feature gsf)
		$(meson_feature heif)
		$(meson_feature heif heif-module)
		$(meson_feature highway)
		$(meson_native_use_feature imagemagick magick)
		-Dmagick-package=$(usex graphicsmagick GraphicsMagick MagickCore)
		# -Dmagick-features="[load,save]"
		$(meson_native_use_feature imagequant)
		$(meson_native_use_feature introspection)
		$(meson_feature jpeg)
		$(meson_feature jpeg2k openjpeg)
		$(meson_feature jpegxl jpeg-xl)
		$(meson_feature jpegxl jpeg-xl-module)
		$(meson_feature lcms)
		$(meson_native_use_feature matio)
		$(meson_feature nifti)
		$(usex nifti '-Dnifti-prefix-dir=/usr' '')
		$(meson_native_use_feature openexr) # v3 have no multilib, and v2 is no more in gentoo
		$(meson_native_use_feature openslide)
		$(meson_native_use_feature openslide openslide-module)
		$(meson_feature orc)
		$(meson_feature pango pangocairo)
		# $(meson_feature pdfium)
		-Dpdfium=disabled
		# 👆fucking google "gn" buildsystem.
		# I don't wan't to fuck with that to package pdfium, sorry.
		# Use poppler instead.
		$(meson_feature png)
		$(meson_native_use_feature pdf poppler)
		$(meson_native_use_feature pdf poppler-module)
		# $(meson_feature quantizr)
		-Dquantizr=disabled # use imagequant instead
		$(meson_feature spng)
		$(meson_feature svg rsvg)
		$(meson_feature tiff)
		$(meson_feature webp)
		$(meson_feature svg zlib) # zlib is currently only used by svgload.c

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

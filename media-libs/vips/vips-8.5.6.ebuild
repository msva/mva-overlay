# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils autotools python-single-r1 multilib-minimal

DESCRIPTION="VIPS Image Processing Library"
SRC_URI="https://github.com/jcupitt/lib${PN}/archive/v${PV}.tar.gz -> lib${P}.tar.gz"
HOMEPAGE="http://www.vips.ecs.soton.ac.uk/index.php?title=VIPS"

RESTRICT="mirror"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="cxx doc debug exif fits fftw graphicsmagick imagemagick jpeg lcms matio openexr openslide
	+orc png python svg static-libs tiff webp"

RDEPEND="
	debug? ( dev-libs/dmalloc )
	>=dev-libs/glib-2.6:2
	dev-libs/libxml2
	sys-libs/zlib
	>=x11-libs/pango-1.8
	fftw? ( sci-libs/fftw:3.0= )
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick )
		!graphicsmagick? ( media-gfx/imagemagick )
	)
	lcms? ( media-libs/lcms )
	svg? ( gnome-base/librsvg )
	matio? ( >=sci-libs/matio-1.3.4 )
	openexr? ( >=media-libs/openexr-1.2.2 )
	exif? ( >=media-libs/libexif-0.6 )
	tiff? ( media-libs/tiff:0= )
	jpeg? ( virtual/jpeg:0= )
	fits? ( sci-libs/cfitsio )
	png? ( >=media-libs/libpng-1.2.9:0= )
	python? ( ${PYTHON_DEPS} )
	webp? ( media-libs/libwebp )
	orc? ( >=dev-lang/orc-0.4.11 )
	openslide? ( media-libs/openslide )
"
DEPEND="
	${RDEPEND}
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

S="${WORKDIR}/lib${P}"

DOCS=(ChangeLog NEWS THANKS TODO README.md)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -r \
		-e '/define VIPS_VERSION_STRING/s#@VIPS_VERSION_STRING@#@VIPS_VERSION@#' \
		-i "${S}"/libvips/include/vips/version.h.in || die

	default

	gtkdocize --copy --docdir doc --flavour no-tmpl
	# ^ the way portage calling it doesn't work, so let's call manually

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local magick="--without-magick";
	use imagemagick && magick="--with-magickpackage=MagickCore"
	use graphicsmagick && magick="--with-magickpackage=GraphicsMagick"

	econf \
		${magick} \
		$(multilib_native_use_enable doc gtk-doc) \
		$(use_enable debug) \
		$(use_with debug dmalloc) \
		$(use cxx || echo "--disable-cxx") \
		$(use_with fftw) \
		$(use_with lcms) \
		$(use_with openexr OpenEXR) \
		$(use_with matio ) \
		$(use_with exif libexif) \
		$(use_with png) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		$(use_with fits cfitsio) \
		$(use_with jpeg) \
		$(use_with orc) \
		$(use_with python) \
		$(use_with webp libwebp) \
		$(use_with openslide) \
		$(use_enable static-libs static) \
		--with-html-dir="/usr/share/gtk-doc/html"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}
multilib_src_install_all() {
	einstalldocs
	use python && python_optimize
	prune_libtool_files
}

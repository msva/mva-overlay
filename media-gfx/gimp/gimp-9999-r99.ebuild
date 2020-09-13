# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit meson python-single-r1 xdg git-r3

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="https://www.gimp.org/"
EGIT_REPO_URI="https://github.com/GNOME/gimp"
LICENSE="GPL-3 LGPL-3"
SLOT="2"

IUSE="aalib alsa aqua debug doc heif javascript jpeg2k lua mng openexr postscript python test udev unwind vector-icons webp wmf xpm"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/bzip2
	>=app-arch/xz-utils-5.0.0
	>=app-text/poppler-0.50[cairo]
	>=app-text/poppler-data-0.4.7
	>=dev-libs/atk-2.2.0
	>=dev-libs/glib-2.56.0:2
	dev-libs/libxml2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.40.6:2
	>=media-gfx/mypaint-brushes-1.3.0
	>=media-libs/babl-0.1.72
	>=media-libs/fontconfig-2.12.4
	>=media-libs/freetype-2.1.7
	>=media-libs/gegl-0.4.18:0.4[cairo]
	>=media-libs/gexiv2-0.10.6
	>=media-libs/harfbuzz-0.9.19
	>=media-libs/lcms-2.8:2
	>=media-libs/libmypaint-1.3.0:=
	>=media-libs/libpng-1.6.25:0=
	>=media-libs/tiff-3.5.7:0
	net-libs/glib-networking[ssl]
	sys-libs/zlib
	virtual/jpeg:0
	>=x11-libs/cairo-1.12.2
	>=x11-libs/gdk-pixbuf-2.31:2
	>=x11-libs/gtk+-3.16.10:3
	x11-libs/libXcursor
	>=x11-libs/pango-1.29.4
	aalib? ( media-libs/aalib )
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	aqua? ( >=x11-libs/gtk-mac-integration-2.0.0 )
	heif? ( >=media-libs/libheif-1.3.2:= )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2= )
	mng? ( media-libs/libmng:= )
	openexr? ( >=media-libs/openexr-1.6.1:= )
	postscript? ( app-text/ghostscript-gpl )
	python?	(
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		')
	)
	udev? ( dev-libs/libgudev:= )
	unwind? ( >=sys-libs/libunwind-1.1.0:= )
	webp? ( >=media-libs/libwebp-0.6.0:= )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	xpm? ( x11-libs/libXpm )
"

RDEPEND="
	${COMMON_DEPEND}
	x11-themes/hicolor-icon-theme
"

DEPEND="
	${COMMON_DEPEND}
	>=dev-lang/perl-5.10.0
	dev-libs/appstream-glib
	dev-util/gtk-update-icon-cache
	>=dev-util/intltool-0.40.1
	sys-apps/findutils
	>=sys-devel/automake-1.11
	>=sys-devel/gettext-0.19
	>=sys-devel/libtool-2.2
	virtual/pkgconfig
"

DOCS=( "AUTHORS" "ChangeLog" "HACKING" "NEWS" "README" "README.i18n" )

# Bugs 685210 (and duplicate 691070)
PATCHES=(
	"${FILESDIR}/${PN}-2.10_fix_test-appdata.patch"
)

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

_adjust_sandbox() {
	# Bugs #569738 and #591214
	local nv
	for nv in /dev/nvidia-uvm /dev/nvidiactl /dev/nvidia{0..9} ; do
		# We do not check for existence as they may show up later
		# https://bugs.gentoo.org/show_bug.cgi?id=569738#c21
		addwrite "${nv}"
	done

	addwrite /dev/dri/  # bugs #574038 and #684886
	addwrite /dev/ati/  # bug #589198
	addwrite /proc/mtrr  # bug #589198
}

src_configure() {
	_adjust_sandbox

	local emesonargs=(
	# Defaults:
#		-Denable-console-bin=$(usex cli true false)
#		-Denable-default-bin=$(usex gtk3 true false)
#		-Dicc-directory='/usr/share/color/icc' # default ATM

	# Disabled Features
		-Dcheck-update=false
		-Dlibbacktrace=false
		-Dwebkit=disabled
		-Dxvfb-run=disabled

	# Enabled Features:
		-Dappdata-test=enabled #maybe false and rm patch?
		-Denable-multiproc=true
		-Djpeg=enabled
		-Dpng=enabled
		-Dtiff=enabled
		-Dxcursor=enabled
		-Dpoppler=true

		-Dprint=enabled # ?

#		-Dcairo-pdf=
#		-Dgtk-doc=
#		-Dscreenshot=

	# User choice:
		-Dlibunwind=$(usex unwind true false)
		-Daa=$(usex aalib enabled disabled)
		-Dalsa=$(usex alsa enabled disabled)
		-Dghostscript=$(usex postscript enabled disabled)
		-Dgudev=$(usex udev enabled disabled)
		-Dheif=$(usex heif enabled disabled)
		-Djpeg2000=$(usex jpeg2k enabled disabled)
		-Dmng=$(usex mng enabled disabled)
		-Dopenexr=$(usex openexr enabled disabled)
		-Dwebp=$(usex webp enabled disabled)
		-Dwmf=$(usex wmf enabled disabled)
		-Dxpm=$(usex xpm enabled disabled)
		-Dvec-icons=$(usex vector-icons true false)
		-Djavascript=$(usex javascript always never)
		-Dlua=$(usex lua always never)
		-Dpython=$(usex python always never)
	)
	meson_src_configure
}

src_compile() {
	export XDG_DATA_DIRS="${EPREFIX}"/usr/share  # bug 587004
	meson_src_compile
}

# for https://bugs.gentoo.org/664938
_rename_plugins() {
	einfo 'Renaming plug-ins to not collide with pre-2.10.6 file layout (bug #664938)...'
	local prepend=gimp-org-
	(
		cd "${ED%/}"/usr/$(get_libdir)/gimp/2.0/plug-ins || exit 1
		for plugin_slash in $(ls -d1 */); do
		    plugin=${plugin_slash%/}
		    if [[ -f ${plugin}/${plugin} ]]; then
			# NOTE: Folder and file name need to match for Gimp to load that plug-in
			#       so "file-svg/file-svg" becomes "${prepend}file-svg/${prepend}file-svg"
			mv ${plugin}/{,${prepend}}${plugin} || exit 1
			mv {,${prepend}}${plugin} || exit 1
		    fi
		done
	)
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install

	if use python; then
		python_optimize
	fi

	# Workaround for bug #321111 to give GIMP the least
	# precedence on PDF documents by default
	mv "${ED%/}"/usr/share/applications/{,zzz-}gimp.desktop || die

	find "${D}" -name '*.la' -type f -delete || die

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	local gimp_app_version=$(get_version_component_range 1-2)
	mv "${ED%/}"/usr/share/man/man1/gimp-console{-${gimp_app_version},}.1 || die

	# Remove gimp devel-docs html files if user doesn't need it
	if ! use doc; then
		rm -r "${ED%/}"/usr/share/gtk-doc || die
	fi

	_rename_plugins || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

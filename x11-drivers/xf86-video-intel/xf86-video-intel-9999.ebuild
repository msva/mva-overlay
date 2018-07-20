# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
#    ^ fucking xorg-2.eclass :'(

XORG_DRI=dri
XORG_EAUTORECONF=yes
inherit linux-info xorg-2

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS=""
IUSE="dri3 debug +sna +udev uxa xvmc"

REQUIRED_USE="
	|| ( sna uxa )
"

RDEPEND="
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.29[video_cards_intel]
	sna? (
		>=x11-base/xorg-server-1.10
	)
	udev? (
		virtual/udev
	)
	xvmc? (
		x11-libs/libXvMC
		>=x11-libs/libxcb-1.5
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable dri)
		$(usex dri3 "--with-default-dri=3")
		$(use_enable sna)
		$(use_enable uxa)
		$(use_enable udev)
		$(use_enable xvmc)
	)
	xorg-2_src_configure
}

pkg_postinst() {
	if linux_config_exists \
		&& ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "	      i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}

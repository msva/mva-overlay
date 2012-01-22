# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION=""
HOMEPAGE="https://github.com/Bumblebee-Project/Bumblebee"

if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="git-2"
	EGIT_REPO_URI="https://github.com/Bumblebee-Project/${PN/bu/Bu}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Bumblebee-Project/${PN/bu/Bu}/${P/bu/Bu}.tar.gz"
	KEYWORDS="amd64 x86"
fi;

inherit multilib eutils ${SCM_ECLASS}

SLOT="0"
LICENSE="GPL-2"

IUSE="video_cards_nouveau video_cards_nvidia"

RDEPEND="x11-misc/virtualgl
	sys-kernel/bbswitch
	virtual/opengl
	x11-base/xorg-drivers[video_cards_nvidia?,video_cards_nouveau?]"
DEPEND=">=sys-devel/autoconf-2.68
	sys-devel/automake
	sys-devel/gcc
	dev-util/pkgconfig
	dev-libs/glib:2
	x11-libs/libX11
	dev-libs/libbsd
	sys-apps/help2man
	${RDEPEND}"
src_configure() {
	( ! use video_cards_nvidia && ! use video_cards_nouveau ) && \
	die "You should enable at least one of supported VIDEO_CARDS!"

	use video_cards_nvidia &&
	ECONF_PARAMS="CONF_DRIVER=nvidia CONF_DRIVER_MODULE_NVIDIA=nvidia \
	CONF_LDPATH_NVIDIA=/usr/$(get_libdir)/opengl/nvidia/lib \
	CONF_MODPATH_NVIDIA=/usr/$(get_libdir)/opengl/nvidia/lib,/usr/$(get_libdir)/opengl/nvidia/extensions,/usr/$(get_libdir)/xorg/modules/drivers,/usr/$(get_libdir)/xorg/modules"
	econf ${ECONF_PARAMS}
}

src_install() {
	use video_cards_nvidia && newconfd "${FILESDIR}"/bumblebee.nvidia-confd bumblebee
	use video_cards_nouveau && newconfd "${FILESDIR}"/bumblebee.nouveau-confd bumblebee
	newinitd "${FILESDIR}"/bumblebee.initd bumblebee
	default
}

pkg_preinst() {
	enewgroup bumblebee;
}

pkg_postinst() {
	! use video_cards_nvidia && rm "${DESTDIR}"/etc/bumblebee/xorg.conf.nvidia
	! use video_cards_nouveau && rm "${DESTDIR}"/etc/bumblebee/xorg.conf.nouveau

	ewarn "This is *NOT* all! Bumblebee still *NOT* ready to use."
	ewarn "You may need to setup your /etc/bumblebee/bumblebee.conf!"
	ewarn "Also you should add you user to 'bumblebee' group."
}
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="Powerful Qt5 chat client for net-libs/tox that follows the Tox design guidelines"
HOMEPAGE="https://github.com/tux3/qtox"
EGIT_REPO_URI="https://github.com/tux3/qtox.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk"

RDEPEND="
	dev-db/sqlcipher
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[gif,jpeg,png,xcb]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	media-gfx/qrencode
	media-libs/openal
	>=media-video/ffmpeg-2.6.3[webp,v4l]
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		x11-libs/gdk-pixbuf[X]
		x11-libs/gtk+:2
		x11-libs/cairo[X]
		x11-libs/pango[X]
	)
	net-libs/tox[av]
	x11-libs/libX11
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
"
pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(tc-getCXX) == *g++ ]] ; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 8 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.8.3"
				die "You need at least sys-devel/gcc-4.8.3"
			fi
		fi
	fi
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit python-single-r1 xdg eutils git-r3 toolchain-funcs

DESCRIPTION="A curses-based client for Tox."
HOMEPAGE="https://wiki.tox.chat/clients/toxic"
SRC_URI=""
EGIT_REPO_URI="https://github.com/JFreegman/toxic"

LICENSE="GPL-3"
SLOT="0"
IUSE="+X +av +libnotify +sound-notify +python +qrcode"

RDEPEND="
	net-libs/tox:0/0.1
	av? (
		net-libs/tox:0/0.1[av]
		media-libs/libvpx:=
		x11-libs/libX11
	)
	dev-libs/libconfig
	net-misc/curl:0=
	sys-libs/ncurses:0=
	sound-notify? ( media-libs/openal media-libs/freealut )
	libnotify? ( x11-libs/libnotify )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode )
"
DEPEND="
	${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

u10() {
	usex ${1} 1 0
}

src_prepare() {
	sed  \
		-e 's/@$(CC)/$(CC)/' \
		-e '/global_vars.mk$/a-include $(BASE_DIR)/cfg.mk' \
		-i Makefile || die
	default
}

src_configure() {
	local myconfigopts=(
		DISABLE_AV=$(u10 !av)
		DISABLE_DESKTOP_NOTIFY=$(u10 libnotify)
		DISABLE_SOUND_NOTIFY=$(u10 sound-notify)
		DISABLE_X11=$(u10 X)
		DISABLE_QRPNG=$(u10 qrcode)
		ENABLE_PYTHON=$(u10 python)
		CC="$(tc-getCC)"
		USER_CFLAGS="${CFLAGS}"
		USER_LDFLAGS="${LDFLAGS}"
		PREFIX="/usr"
	)
	for c in "${myconfigopts[@]}"; do
		echo "${c}" >> cfg.mk;
	done
}

pkg_postinst() {
	elog "DHT node list is available in /usr/share/${PN}/DHTnodes"
}

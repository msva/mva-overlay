# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="CLI Frontend for Tox"
HOMEPAGE="https://wiki.tox.chat/clients/toxic"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Tox/toxic"

LICENSE="GPL-3"
SLOT="0"
IUSE="+av +libnotify +sound-notify +X"

RDEPEND="
	av? (
		|| (
			media-libs/openal[alsa]
			media-libs/openal[pulseaudio]
		)
	)
	net-libs/tox[av=]
	libnotify? ( x11-libs/libnotify )
	sound-notify? ( media-libs/freealut )
	X? ( x11-libs/libX11 )
	sys-libs/ncurses:*
	media-gfx/qrencode
	dev-libs/libconfig
"
DEPEND="
	${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
"

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
		DISABLE_AV=$(u10 av)
		DISABLE_DESKTOP_NOTIFY=$(u10 libnotify)
		DISABLE_SOUND_NOTIFY=$(u10 sound-notify)
		DISABLE_X11=$(u10 X)
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

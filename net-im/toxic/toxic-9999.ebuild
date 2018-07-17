# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} pypy3 )

inherit patches python-single-r1 xdg eutils git-r3 toolchain-funcs

DESCRIPTION="A curses-based client for Tox."
HOMEPAGE="https://wiki.tox.chat/clients/toxic"
SRC_URI=""
EGIT_REPO_URI="https://github.com/JFreegman/toxic"

LICENSE="GPL-3"
SLOT="0"
IUSE="+X +audio +notifications +python +qrcode +video"

RDEPEND="
	audio? (
		net-libs/tox[av]
		media-libs/openal
		media-libs/freealut
	)
	video? (
		net-libs/tox[av]
		media-libs/libvpx:=
		x11-libs/libX11
	)
	net-libs/tox:0/0.1
	dev-libs/libconfig
	net-misc/curl:0=
	sys-libs/ncurses:0=
	notifications? ( x11-libs/libnotify )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode )
	X? ( x11-libs/libX11 )
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
		-e '/^LIBS/{
			s@ toxcore @ libtoxcore @;
			a-include $(BASE_DIR)/cfg.mk
		}' \
		-i Makefile || die

	patches_src_prepare
}

src_configure() {
	local myconfigopts=(
		DISABLE_AV=$(u10 !audio)
		DISABLE_VI=$(u10 !video)
		DISABLE_DESKTOP_NOTIFY=$(u10 notifications)
		DISABLE_SOUND_NOTIFY=$(u10 audio)
		DISABLE_X11=$(u10 X)
		DISABLE_QRPNG=$(u10 qrcode)
		ENABLE_PYTHON=$(u10 python)
		CC="$(tc-getCC)"
		USER_CFLAGS="${CFLAGS}"
		USER_LDFLAGS="${LDFLAGS}"
		PREFIX="${EROOT}usr"
	)

	if use audio || use video; then
		myconfigopts+=("LIBS+=libtoxav")
	fi

	for c in "${myconfigopts[@]}"; do
		echo "${c}" >> cfg.mk;
	done
}

pkg_postinst() {
	elog "DHT node list is available in /usr/share/${PN}/DHTnodes"
}

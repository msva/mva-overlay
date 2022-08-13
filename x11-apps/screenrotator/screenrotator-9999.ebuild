# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/GuLinux/ScreenRotator"

DESCRIPTION="Automatic screen rotation daemon for X11"
HOMEPAGE="https://github.com/GuLinux/ScreenRotator"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsensors:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	virtual/libc
"
DEPEND="${RDEPEND}"

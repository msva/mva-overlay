# Copyright 2025 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_MPV="rdepend"
MPV_REQ_USE="lua"
inherit mpv-plugin

MY_SHA="9deb0733c4e36938cf90e42ddfb7a19a8b2f4641"
DESCRIPTION="High-performance on-the-fly thumbnailer script for mpv"
HOMEPAGE="https://github.com/po5/thumbfast"
SRC_URI="https://github.com/po5/${PN}/archive/${MY_SHA}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_SHA}"

LICENSE="MPL-2.0"
KEYWORDS="~amd64"

RDEPEND="app-shells/bash"

MPV_PLUGIN_FILES=(
	thumbfast.lua
)

DOCS=(
	thumbfast.conf
	README.md
)

pkg_postinst() {
	mpv-plugin_pkg_postinst
}

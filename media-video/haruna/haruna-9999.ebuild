# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ar ast ca ca@valencia cs de en_GB eo es eu fi fr gl he hi ia id it ja ka ko lt lv nl pl pt pt_BR ro ru sk sl sv ta tr uk zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit cmake plocale xdg

DESCRIPTION="Video player built with Qt/QML on top of libmpv"
HOMEPAGE="https://invent.kde.org/multimedia/haruna"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://invent.kde.org/multimedia/${PN}.git"
else
	MY_P="${PN}-v${PV}"
	SRC_URI="https://invent.kde.org/multimedia/${PN}/-/archive/v${PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-libs/kdsingleapplication
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	kde-frameworks/breeze-icons:6
	kde-frameworks/kcolorscheme:6
	kde-frameworks/kconfig:6
	kde-frameworks/kcoreaddons:6
	kde-frameworks/kfilemetadata:6
	kde-frameworks/ki18n:6
	kde-frameworks/kiconthemes:6
	kde-frameworks/kio:6
	kde-frameworks/kirigami:6
	kde-frameworks/kwindowsystem:6
	media-libs/mpvqt:6
	media-video/ffmpeg:0=
	net-misc/yt-dlp
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	sys-devel/gettext
"

src_prepare() {
	my_rm_loc() {
		rm -rf po/"${1}" || die "rm failed for po/${1}"
	}
	plocale_for_each_disabled_locale my_rm_loc

	cmake_src_prepare
}

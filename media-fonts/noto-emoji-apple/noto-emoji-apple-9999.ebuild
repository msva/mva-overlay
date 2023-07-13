# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font git-r3

MY_PN="noto-fonts-emoji-apple"

DESCRIPTION="Google Noto Emoji Fonts replaced with Apple branded emoji"
HOMEPAGE="https://gitlab.com/timescam/noto-fonts-emoji-apple https://forum.xda-developers.com/apps/magisk/magisk-ios-13-2-emoji-t3993487"
EGIT_REPO_URI="https://gitlab.com/timescam/noto-fonts-emoji-apple.git"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"

RESTRICT="binchecks strip"

# Although there's no file conflict, it will be "conflict" in runtime
# because of ttf font naming.
RDEPEND="!!media-fonts/noto-emoji"

# FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS=( README.md )

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Noto Emoji (patched for Apple emojis) virtual package"

SLOT="0"

RDEPEND="
	|| (
		media-fonts/noto-emoji[apple-icons(-)]
		media-fonts/noto-emoji[apple-icons(-)]
	)
"

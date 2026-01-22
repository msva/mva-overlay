# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="Noto Emoji (patched for Apple emojis) virtual package"

SLOT="0"

RDEPEND="
	|| (
		media-fonts/noto-emoji[apple-icons(-)]
		media-fonts/noto-emoji[apple-icons(-)]
	)
"

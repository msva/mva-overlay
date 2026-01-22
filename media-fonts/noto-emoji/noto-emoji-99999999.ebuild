# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit font git-r3

MY_PN="noto-fonts-emoji-apple"

DESCRIPTION="Google Noto Emoji Fonts replaced with Apple branded emoji"
HOMEPAGE="https://gitlab.com/timescam/noto-fonts-emoji-apple https://xdaforums.com/t/magisk-module-ios-13-2-emoji.3993487/"
EGIT_REPO_URI="https://gitlab.com/timescam/${MY_PN}"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"

IUSE="apple-icons"

RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
DOCS=( README.md )

pkg_pretend() {
	if ! use apple-icons; then
		die "\tThis ebuild currently only supports installing noto-emoji-apple." \
			"\n\tThe package name was hijacked from google's noto package" \
				"because it appeared as mandatory dependency for plasma" \
			"\n\t(so it became a blocker for this font, but many users would consider apple's emojis beautifier)" \
			"\n\t(but it is probably no way for apple-patched font to be packaged 'officialy'" \
			"\n\t(as well as come to plasma) because of potential licensing issues)" \
			"\n" \
			"\n\tYou are seeing this message because you should make conscious decision" \
			"\n\twhether you want to get hijacked font with apple emojis, or original google ones" \
			"\n" \
			"\n\tTL;DR: Please, just enable 'apple-icons' USE-flag on '=${CATEGORY}/${P}'"
	fi
}

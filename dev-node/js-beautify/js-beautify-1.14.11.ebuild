# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Beautifier for javascript https://beautifier.io"
HOMEPAGE="https://github.com/beautifier/js-beautify"

S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
RESTRICT="network-sandbox"

NPM_NO_DEPS=0

NPM_BINS="
	css-beautify.js => css-beautify
	html-beautify.js => html-beautify
	js-beautify.js => js-beautify
"

# Requires 'src' directory
NPM_PKG_DIRS="src"

inherit npmv1

# npmv1 doesn't understand that js-beautify's
# 'bin' and 'lib' directories are located in the 'js' directory.
src_unpack() {
	default

	mv "${S}"/js/* "${S}"
}

src_install() {
	npmv1_src_install

	# Might not be needed
	insinto "${NPM_PACKAGEDIR}"
	doins "${S}"/index.js
}

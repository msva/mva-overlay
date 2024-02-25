# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="https://think-async.com/Asio/"
EGIT_REPO_URI="https://github.com/chriskohlhoff/${PN}.git"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="doc examples ssl test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	eautoreconf
	default

	if ! use test; then
		# Don't build nor install any examples or unittests
		# since we don't have a script to run them
		cat > src/Makefile.in <<-EOF || die
			all:

			install:

			clean:
		EOF
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/. )
	default

	if use examples; then
		# Get rid of the object files
		emake clean
		dodoc -r src/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

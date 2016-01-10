# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit git-r3 flag-o-matic python-any-r1 eutils

DESCRIPTION="A hackable text editor for the 21st Century"
HOMEPAGE="https://atom.io/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/atom/atom"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	|| ( net-libs/nodejs[npm] net-libs/iojs[npm] )
	media-fonts/inconsolata
	gnome-base/gconf
	x11-libs/gtk+:2
	gnome-base/libgnome-keyring
	x11-libs/libnotify
	x11-libs/libXtst
	dev-libs/nss
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-any-r1_pkg_setup

	npm config set python "${PYTHON}"
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	sed -i \
		-e "1a\nexport PYTHON=${PYTHON}\n" \
		atom.sh

	sed -i \
		-e "/exception-reporting/d" \
		-e "/metrics/d" \
		package.json

	sed \
		-e "s/<%= description %>/$pkgdesc/" \
		-e "s|<%= executable %>|/usr/bin/atom|" \
		-e "s|<%= iconName %>|atom|" \
		resources/linux/atom.desktop.in > resources/linux/Atom.desktop

	# Fix atom location guessing
	sed -i \
		-e 's/ATOM_PATH="$USR_DIRECTORY\/share\/atom/ATOM_PATH="$USR_DIRECTORY\/../g' \
		./atom.sh || die "Fail fixing atom-shell directory"

	# Make bootstrap process more verbose
	sed -i \
		-e 's@node script/bootstrap@node script/bootstrap --no-quiet@g' \
		./script/build || die "Fail fixing verbosity of script/build"

	sed -i \
		-e 's:/usr/local:/usr:' \
		src/command-installer.coffee \
		build/Gruntfile.coffee \
		script/cibuild-atom-linux
}

src_compile() {
	./script/build --verbose --build-dir "${T}" || die "Failed to compile"
	"${T}/Atom/resources/app/apm/bin/apm" rebuild || die "Failed to rebuild native module"
	echo "python = $PYTHON" >> "${T}/Atom/resources/app/apm/.apmrc"
}


src_install() {
	insinto /usr/share/"${PN}"
	doins -r "${T}"/Atom/*
	insinto /usr/share/applications
	newins resources/linux/Atom.desktop atom.desktop
	insinto /usr/share/pixmaps
	doins resources/atom.png
	insinto /usr/share/licenses/"${PN}"
	doins LICENSE.md
	# Fixes permissions
	fperms +x "${EPREFIX}/usr/share/${PN}/${PN}"
	fperms +x "${EPREFIX}/usr/share/${PN}/libchromiumcontent.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libffmpegsumo.so"
	fperms +x "${EPREFIX}/usr/share/${PN}/libgcrypt.so.11"
	fperms +x "${EPREFIX}/usr/share/${PN}/libnotify.so.4"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/atom.sh"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/apm"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/node"
	fperms +x "${EPREFIX}/usr/share/${PN}/resources/app/apm/node_modules/npm/bin/node-gyp-bin/node-gyp"
	# Symlinking to /usr/bin
	dosym "${EPREFIX}/usr/share/${PN}/resources/app/atom.sh" /usr/bin/atom
	dosym "${EPREFIX}/usr/share/${PN}/resources/app/apm/bin/apm" /usr/bin/apm
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Skype API Plugin for Pidgin"
HOMEPAGE="http://eion.robbmob.com/"
EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="skypeapi dbus nls"
SLOT="0"
SRC_URI=""

RDEPEND="
	net-im/pidgin
	dbus? ( >sys-apps/dbus-1.0 )
	skypeapi? ( net-im/skype )
"

DEPEND="
	${RDEPEND}
	>dev-libs/glib-2.0
	>dev-libs/json-glib-1.0
"

src_compile() {
	GLIB_CFLAGS="-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include"
	LIBPURPLE_CFLAGS="-I/usr/include/libpurple -DPURPLE_PLUGINS"
	SKYPEWEB_LIBS="-I/usr/include/json-glib-1.0 -ljson-glib-1.0 -lgio-2.0 -lgobject-2.0 -lpurple -lglib-2.0 "

	if use nls; then
		LIBPURPLE_CFLAGS="${LIBPURPLE_CFLAGS} -DENABLE_NLS"
	fi

	CFLAGS="${CFLAGS} ${LIBPURPLE_CFLAGS} -Wall -pthread ${GLIB_CFLAGS} -I. -shared -fPIC -DPIC"

	if use amd64; then
		CFLAGS="${CFLAGS} -m32 -m64"
	fi

	if use skypeapi; then
		cc ${CFLAGS} -o libskype.so libskype.c || die 'Error compiling library!'
		cc ${CFLAGS} -DSKYPENET -o libskypenet.so libskype.c || die 'Error compiling library!'

		if use dbus; then
			DBUS_CFLAGS="-DSKYPE_DBUS -I/usr/include/dbus-1.0
			-I/usr/lib/dbus-1.0/include -o libskype_dbus.so"
			cc ${CFLAGS} ${DBUS_CFLAGS} -o libskype_dbus.so libskype.c || die 'Error compiling skypeapi library!'
		fi
		perl -e 'print join("", <>) =~ /(^\[Skype\].*)(?:^\[|\z)/sm' theme >> skypeweb/theme
	fi

	cd skypeweb
	cc ${CFLAGS} ${SKYPEWEB_LIBS} -o libskypeweb.so libskypeweb.c skypeweb_*.c || die 'Error compiling skypeweb library!'
}

src_install() {
	insinto /usr/lib/purple-2
	if use skypeapi; then
		doins "libskype.so"
		doins "libskypenet.so"
		if use dbus; then
			doins "libskype_dbus.so"
		fi
	fi
	cd skypeweb
	doins "libskypeweb.so"

	insinto /usr/share/pixmaps/pidgin/emotes/default-skype
	doins "theme"

	cd icons
	insinto /usr/share/pixmaps/pidgin/protocols/
	doins -r ??
}

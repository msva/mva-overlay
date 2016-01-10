# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit git-2 eutils flag-o-matic toolchain-funcs autotools

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnupg.org/gnupg.git"
#EGIT_BOOTSTRAP="./autogen.sh"
#SRC_URI="mirror://gnupg/gnupg/${P}.tar.bz2"
# SRC_URI="ftp://ftp.gnupg.org/gcrypt/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="adns bzip2 doc ldap nls readline static selinux smartcard usb"

COMMON_DEPEND_LIBS="
	~dev-libs/libassuan-9999
	~dev-libs/libgcrypt-9999
	~dev-libs/libgpg-error-9999
	~dev-libs/libksba-9999
	~dev-libs/npth-9999
	>=net-misc/curl-7.10
	sys-libs/zlib
	adns? ( >=net-libs/adns-1.4 )
	bzip2? ( app-arch/bzip2 )
	readline? ( sys-libs/readline:0 )
	smartcard? ( usb? ( virtual/libusb:0 ) )
	ldap? ( net-nds/openldap )"
COMMON_DEPEND_BINS="app-crypt/pinentry"

# Existence of executables is checked during configuration.
DEPEND="${COMMON_DEPEND_LIBS}
	${COMMON_DEPEND_BINS}
	static? (
		~dev-libs/libassuan-9999[static-libs]
		~dev-libs/libgcrypt-9999[static-libs]
		~dev-libs/libgpg-error-9999[static-libs]
		~dev-libs/libksba-9999[static-libs]
		~dev-libs/npth-9999[static-libs]
		sys-libs/zlib[static-libs]
	)
	nls? ( sys-devel/gettext )
	doc? ( sys-apps/texinfo media-gfx/transfig )"

RDEPEND="!static? ( ${COMMON_DEPEND_LIBS} )
	${COMMON_DEPEND_BINS}
	virtual/mta
	!<=app-crypt/gnupg-2.0.1
	selinux? ( sec-policy/selinux-gpg )
	nls? ( virtual/libintl )"

REQUIRED_USE="smartcard? ( !static )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.17-gpgsm-gencert.patch
	epatch_user
	git-2_src_prepare
	eautoreconf
}

src_configure() {
	local myconf

	# 'USE=static' support was requested:
	# gnupg1: bug #29299
	# gnupg2: bug #159623
	use static && append-ldflags -static

	if use smartcard; then
		myconf+=" --enable-scdaemon $(use_enable usb ccid-driver)"
	else
		myconf+=" --disable-scdaemon"
	fi

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-gpg \
		--enable-gpgsm \
		--enable-agent \
		--enable-gpgtar \
		--enable-gpg2-is-gpg \
		--enable-maintainer-mode \
		${myconf} \
		$(use_with adns) \
		$(use_enable bzip2) \
		$(use_enable doc) \
		$(use_enable !elibc_SunOS symcryptrun) \
		$(use_enable nls) \
		$(use_enable ldap) \
		$(use_with readline) \
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
}

src_compile() {
	emake

	if use doc; then
		cd doc
		emake html
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" -f doc/Makefile uninstall-nobase_dist_docDATA

	dodoc ChangeLog NEWS README THANKS TODO doc/FAQ doc/DETAILS \
		doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER doc/help*

	dosym gpg2 /usr/bin/gpg
	dosym gpgv2 /usr/bin/gpgv
	dosym gpg2keys_hkp /usr/libexec/gpgkeys_hkp
	dosym gpg2keys_finger /usr/libexec/gpgkeys_finger
	dosym gpg2keys_curl /usr/libexec/gpgkeys_curl
	if use ldap; then
		dosym gpg2keys_ldap /usr/libexec/gpgkeys_ldap
	fi
	echo ".so man1/gpg2.1" > "${ED}usr/share/man/man1/gpg.1"
	echo ".so man1/gpgv2.1" > "${ED}usr/share/man/man1/gpgv.1"

	dodir /etc/env.d
	echo "CONFIG_PROTECT=/usr/share/gnupg/qualified.txt" >>"${ED}etc/env.d/30gnupg"

	if use doc; then
		dohtml doc/gnupg.html/* doc/*.png
	fi
}

pkg_postinst() {
	elog "If you wish to view images emerge:"
	elog "media-gfx/xloadimage, media-gfx/xli or any other viewer"
	elog "Remember to use photo-viewer option in configuration file to activate"
	elog "the right viewer."
	elog

	if use smartcard; then
		elog "To use your OpenPGP smartcard (or token) with GnuPG you need one of"
		use usb && elog " - a CCID-compatible reader, used directly through libusb;"
		elog " - sys-apps/pcsc-lite and a compatible reader device;"
		elog " - dev-libs/openct and a compatible reader device;"
		elog " - a reader device and drivers exporting either PC/SC or CT-API interfaces."
		elog ""
		elog "General hint: you probably want to try installing sys-apps/pcsc-lite and"
		elog "app-crypt/ccid first."
	fi

	ewarn "Please remember to restart gpg-agent if a different version"
	ewarn "of the agent is currently used. If you are unsure of the gpg"
	ewarn "agent you are using please run 'killall gpg-agent',"
	ewarn "and to start a fresh daemon just run 'gpg-agent --daemon'."
}

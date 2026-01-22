# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit meson systemd git-r3 patches

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="https://tinc-vpn.org/"

EGIT_BRANCH="1.1"
EGIT_REPO_URI="https://tinc-vpn.org/git/tinc"
EGIT_MIN_CLONE_TYPE="single"

LICENSE="GPL-2"
SLOT="0"

IUSE="gcrypt gui +legacy +lzo +lz4 +ncurses +readline systemd tools uml vde upnp +zlib"

DEPEND="
	legacy? (
		gcrypt? ( dev-libs/libgcrypt:0= )
		!gcrypt? ( dev-libs/openssl:0= )
	)
	lzo? ( dev-libs/lzo:2 )
	lz4? ( app-arch/lz4:0 )
	ncurses? ( sys-libs/ncurses:0 )
	readline? ( sys-libs/readline:0 )
	upnp? ( net-libs/miniupnpc )
	zlib? ( virtual/zlib )
"
RDEPEND="
	${DEPEND}
	vde? ( net-misc/vde )
"

#REQUIRED_USE="^^ ( ssl gcrypt )"

src_prepare() {
	patches_src_prepare
}

src_configure() {
	local emesonargs=(
		-Drunstatedir="${EPREFIX}"/run
		-Djumbograms=true
		-Dtunemu=disabled
		-Dsystemd_dir="$(systemd_get_systemunitdir)"
		-Dcrypto=$(usex legacy $(usex gcrypt gcrypt openssl) nolegacy)
		$(meson_feature lzo)
		$(meson_feature lz4)
		$(meson_feature ncurses curses)
		$(meson_feature readline)
		$(meson_feature systemd)
		$(meson_use uml)
		$(meson_feature vde)
		$(meson_feature upnp miniupnpc)
		$(meson_feature zlib)
	)
	meson_src_configure
}

src_install() {
	meson_install
	dodir /etc/"${PN}"
	newinitd "${FILESDIR}"/tincd.init tincd
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd

	dosym tinc /usr/share/bash-completion/completions/tincd

	DOCS=(AUTHORS NEWS README.md THANKS doc/{CONNECTIVITY,NETWORKING,PROTOCOL,SECURITY2,SPTPS} doc/sample-config)
	einstalldocs
	docompress -x /usr/share/doc/"${PF}"/sample-config
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}

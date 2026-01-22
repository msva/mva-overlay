# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
HOMEPAGE="https://mosh.org"
#EGIT_REPO_URI="https://github.com/mobile-shell/mosh"
EGIT_REPO_URI="https://github.com/alphallc/mosh"
EGIT_BRANCH="patched"

LICENSE="GPL-3"
SLOT="0"
IUSE="+client examples +hardened nettle +server syslog ufw +utempter"

REQUIRED_USE="
	|| ( client server )
	examples? ( client )"

RDEPEND="
	dev-libs/protobuf:=
	sys-libs/ncurses:=
	virtual/zlib
	virtual/ssh
	client? (
		dev-lang/perl
		dev-perl/IO-Tty
	)
	!nettle? ( dev-libs/openssl:= )
	nettle? ( dev-libs/nettle:= )
	utempter? (
		sys-libs/libutempter
	)"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

QA_CONFIGURE_OPTIONS="--disable-static"

# [0] - avoid sandbox-violation calling git describe in Makefile.
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.5-git-version.patch
	# "${FILESDIR}"/${PN}-9999-konsole-support.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	MAKEOPTS+=" V=1"

	local myeconfargs=(
		# We install it ourselves in src_install
		--disable-completion

		$(use_enable client)
		$(use_enable server)
		$(use_enable examples)
		$(use_enable hardened hardening)
		$(use_enable ufw)
		$(use_enable syslog)
		$(use_with utempter)

		# We default to OpenSSL as upstream do
		--with-crypto-library=$(usex nettle nettle openssl-with-openssl-ocb)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	for myprog in $(find src/examples -type f -perm /0111) ; do
		newbin ${myprog} ${PN}-$(basename ${myprog})
		elog "${myprog} installed as ${PN}-$(basename ${myprog})"
	done

	# bug #477384
	dobashcomp conf/bash-completion/completions/mosh
}

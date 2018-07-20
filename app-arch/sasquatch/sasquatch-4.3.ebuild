# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

MY_SHA=59285c81b6dcabbdcb1d5c59b5ca46887fe01726
SPN="squashfs-tools"
SP="${SPN}-${PV}"
DEB_VER="3"

DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net"
SRC_URI="
	mirror://sourceforge/squashfs/squashfs${PV}.tar.gz
	mirror://debian/pool/main/${SPN:0:1}/${SPN}/${SPN}_${PV}-${DEB_VER}.debian.tar.xz
	https://github.com/devttys0/${PN}/archive/${MY_SHA}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+xz lzma lz4 lzo xattr"

RDEPEND="
	sys-libs/zlib
	!xz? ( !lzo? ( sys-libs/zlib ) )
	lz4? ( app-arch/lz4 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
	xz? ( app-arch/xz-utils )
"
DEPEND="${RDEPEND}"

#REQUIRED_USE="^^ ( xz lzma )"

S="${WORKDIR}/squashfs${PV}/squashfs-tools"

src_prepare() {
	rm "${WORKDIR}"/debian/patches/0004-unsquashfs-add-support-for-LZMA-magics.patch

	epatch "${WORKDIR}/${PN}-${MY_SHA}/patches/patch0.txt"
	epatch "${WORKDIR}"/debian/patches/*.patch
	eapply "${FILESDIR}"/${SP}-sysmacros.patch
	eapply "${FILESDIR}"/${SP}-aligned-data.patch
	eapply "${FILESDIR}"/${SP}-2gb.patch
	eapply "${FILESDIR}"/${SP}-local-cve-fix.patch
	eapply "${FILESDIR}"/${SP}-mem-overflow.patch
	eapply "${FILESDIR}"/${SP}-xattrs.patch

	sed -r \
		-e 's@make -C@$(MAKE) -C@' \
		-i Makefile
		#-e '/Both LZMA_XZ_SUPPORT and LZMA_SUPPORT cannot be specified/d' \


	default
}

use10() { usex $1 1 0 ; }

src_configure() {
	# set up make command line variables in EMAKE_SQUASHFS_CONF
	EMAKE_SQUASHFS_CONF=(
#		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 xz)
	)

	tc-export CC
}

src_compile() {
	emake ${EMAKE_SQUASHFS_CONF[@]}
}

src_install() {
	dobin ${PN}
	dodoc "${WORKDIR}/${PN}-${MY_SHA}/README.md"
}

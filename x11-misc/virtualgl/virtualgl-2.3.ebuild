# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Run OpenGL applications on remote display software with full 3D hardware acceleration"
HOMEPAGE="http://www.virtualgl.org/"

if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="subversion"
	ESVN_REPO_URI="https://virtualgl.svn.sourceforge.net/svnroot/virtualgl/vgl/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	MY_PN="VirtualGL"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="amd64 x86"
fi;

inherit cmake-utils ${SCM_ECLASS}

SLOT="0"
LICENSE="LGPL-2.1 wxWinLL-3.1"
IUSE="ssl"

RDEPEND="ssl? ( dev-libs/openssl )
	media-libs/libjpeg-turbo
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXv
	virtual/opengl"

DEPEND="dev-util/cmake
	${RDEPEND}"

src_prepare() {
	ewarn "If you get error about '-fPIC' when linking to"
	ewarn "libjpeg-turbo, then you should build libjpeg-turbo"
	ewarn "from mva overlay and vote bug about -fPIC issue on b.g.o"
	cd "${S}";
	for file in rr/vglgenkey rr/vglrun rr/vglserver_config doc/index.html; do
		sed -e "s#/etc/opt#/etc#g" -i ${file};
	done

	default
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use ssl VGL_USESSL)
		-DVGL_DOCDIR=/usr/share/doc
		-DTJPEG_INCLUDE_DIR=/usr/include
		-DTJPEG_LIBRARY=/usr/$(get_libdir)/libturbojpeg.a
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir /etc/VirtualGL
	fowners root:video /etc/VirtualGL
	fperms 0750 /etc/VirtualGL
	newinitd "${FILESDIR}/vgl.initd" vgl
	newconfd "${FILESDIR}/vgl.confd" vgl
	# Rename glxinfo to vglxinfo to avoid conflict with x11-apps/mesa-progs
	mv "${D}"/usr/bin/{,v}glxinfo
#	rm "${D}/usr/bin/vglserver_config" "${D}/usr/bin/vglgenkey"
}

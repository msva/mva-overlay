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
	multilib? ( app-emulation/emul-linux-x86-xlibs app-emulation/emul-linux-x86-baselibs )
	virtual/opengl"

DEPEND="dev-util/cmake
	${RDEPEND}"

src_prepare() {
	ewarn "Note, that you don't need libjpeg-turbo from my overlay anymore"
	ewarn "(since I've rewrited ebuild to use shared one)"

	cd "${S}";
	for file in rr/vglgenkey rr/vglrun rr/vglserver_config doc/index.html; do
		sed -e "s#/etc/opt#/etc#g" -i ${file};
	done

	default
}

mlib_configure() {
	einfo "Multilib build enabled!"
	einfo "Building 32bit libs..."
	export ml_builddir="${WORKDIR}/build32"
	mkdir -p "${ml_builddir}"
	pushd "${ml_builddir}" >/dev/null

	export CFLAGS="-m32 -O2 -march=i686 -pipe"
	export CXXFLAGS="${CFLAGS}"
	export LDFLAGS="-m32"
	export CMAKE_BUILD_DIR="${ml_builddir}"

	mycmakeargs=(
		$(cmake-utils_use ssl VGL_USESSL)
		-DVGL_DOCDIR=/usr/share/doc/"${P}"
		-DVGL_LIBDIR=/usr/$(get_libdir)
		-DTJPEG_INCLUDE_DIR=/usr/include
		-DTJPEG_LIBRARY=/usr/$(get_libdir)/libturbojpeg.so
		-DCMAKE_LIBRARY_PATH=/usr/lib32
		-DVGL_FAKELIBDIR=/usr/fakelib/32

	)
	cmake-utils_src_configure
	emake || die
	popd >/dev/null
	unset CFLAGS CXXFLAGS LDFLAGS CMAKE_BUILD_DIR
	einfo "Building 64bit libs..."
}

src_configure() {
	use amd64 && use multilib && ABI=x86 mlib_configure
	mycmakeargs=(
		$(cmake-utils_use ssl VGL_USESSL)
		-DVGL_FAKELIBDIR=/usr/fakelib/64
		-DVGL_DOCDIR=/usr/share/doc/"${P}"
		-DTJPEG_INCLUDE_DIR=/usr/include
		-DTJPEG_LIBRARY=/usr/$(get_libdir)/libturbojpeg.so
	)
		cmake-utils_src_configure
}

src_install() {
	use amd64 && use multilib && (
	cd "${ml_builddir}"
	emake DESTDIR="${D}" install || die "Failed to install 32bit libs!"
	cd "${S}"
	)
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

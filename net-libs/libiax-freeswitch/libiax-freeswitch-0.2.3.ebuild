DESCRIPTION=""
HOMEPAGE="http://freeswitch.org/"
LICENSE="LGPL-2"

FS_P='freeswitch-1.0.rc4'
MyPN='iax'
SRC_URI="http://files.freeswitch.org/old/${FS_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug newjb"

DEPEND="
	!net-libs/iax
	!net-libs/libiax
	!net-libs/libiax2
	!net-misc/iaxclient
"
RDEPEND="${DEPEND}"

subS="${FS_P}/libs/${MyPN}"
S="${WORKDIR}/${subS}"

inherit autotools

src_unpack() {
	tar -xzf "${DISTDIR}/${A}" "${subS}"
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable newjb) \
	|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}

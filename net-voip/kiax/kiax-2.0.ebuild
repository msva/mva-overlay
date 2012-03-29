inherit subversion qt4

DESCRIPTION="softphone which aims to provide a flexible architecture for extention and customization"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/tags/2.0/"
ESVN_UP_FREQ='10000' # Tag will never change :)
HOMEPAGE="http://www.forschung-direkt.eu/projects/${PN}/"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="static webkit"
LICENSE="GPL-3 LGPL-2"
SLOT="2"

DEPEND='
	>=x11-libs/qt-gui-4.4
	net-libs/libiaxclient
	dev-db/sqlite:3
	net-libs/json-c
	media-libs/speex
	media-libs/portaudio
	media-sound/gsm
	media-libs/alsa-lib
'

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	
	use static ||
	epatch "${FILESDIR}"/${P}-shared.patch
	
	use webkit &&
	epatch "${FILESDIR}"/${P}-webkit.patch
}

src_compile() {
	eqmake4 kiax2.pro
	emake || die 'emake failed'
}

src_install() {
	newbin gui/gui kiax2
	use static ||
	dolib.so kiax2core/libkiax2core.so*
	dodoc LICENSE.txt
	newdoc kiax2core/LICENSE.txt core_LICENSE.txt
}

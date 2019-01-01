# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="http://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-1:0="
DEPEND="${RDEPEND}
	virtual/os-headers"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.8-flags.patch
	"${FILESDIR}"/${PN}-2.9.9-lib_symlink.patch
)

src_prepare() {
	default

	sed -i -e 's|-O2 -g|$(CFLAGS)|g;s|-g -O2|$(CFLAGS)|g' util/Makefile.am* || die
	sed -i -e 's|which rpm |which we_are_gentoo_rpm_is_a_guest |' configure.ac || die
	sed -i -e "s@=/var@=${EROOT}var@;s@=/usr@=${EROOT}usr@;s@=/etc@=${EROOT}etc@" "scripts/${PN}.env" || die
	sed -i \
		-e '1iprefix = @prefix@' \
		-e '/^prefix/d' \
		-e '/^etcdir/s|/etc|@sysconfdir@|' \
		-e '/^varto/s|/var/lib|@localstatedir@|' \
		Makefile.in doc/Makefile.in doc/Makefile.am scripts/Makefile.in scripts/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --disable-systemd --enable-sha256
}

src_compile() {
	# Ulgy workaround. Upstream is misusing the make system here
	# and it doesn't even work.
	# Please check on each bump if this workaround is still required.
	pushd lib/lanplus &>/dev/null || die
	emake || die "emake lanplus failed"
	cp libipmi_lanplus.a .. || die
	popd &>/dev/null || die

	emake
}

src_install() {
	emake DESTDIR="${D}" sysdto="${D}/$(systemd_get_systemunitdir)" initto="${ED}/etc/init.d" install
	dodoc -r AUTHORS ChangeLog NEWS README TODO doc/UserGuide

	# Init scripts are only for Fedora
	rm -r "${ED%/}"/etc/init.d || die 'remove initscripts failed'

	keepdir /var/lib /var/lib/"${PN}"

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi
}

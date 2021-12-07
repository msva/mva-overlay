# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

MY_PN="SweetHome3D"

DESCRIPTION="Sweet Home 3D is a free interior design application."
HOMEPAGE="http://sweethome3d.com/"
SRC_URI="
	amd64? ( mirror://sourceforge/sweethome3d/${MY_PN}-${PV}-linux-x64.tgz )
	x86? ( mirror://sourceforge/sweethome3d/${MY_PN}-${PV}-linux-x86.tgz )
"
LICENSE="GPL-3"
IUSE="gtk3 +system-java"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	system-java? ( app-eselect/eselect-java )
"
RDEPEND="
	system-java? ( virtual/jre:* )
"

S="${WORKDIR}/${MY_PN}-${PV}"

QA_PREBUILT="*java3d.*.so"

pkg_setup() {
	if use system-java && [ ! -f "$JAVA_HOME"/bin/java ]; then
		die 'Your Java VM installation is broken. Please, select proper system vm through eselect.'
	fi
}

src_prepare() {
	rm THIRDPARTY-LICENSE-* LICENSE.TXT COPYING.TXT
	if use system-java; then
		rm -rf jre* runtime
		sed -r \
			-e 's@^(exec.*/bin/java)@exec "$JAVA_HOME"/bin/java@' \
			-e 's@:"\$PROGRAM_DIR"/[^/]*/(lib/javaws.jar) @:"$JAVA_HOME"/jre/\1:"$JAVA_HOME"/\1:/usr/share/icedtea-web/netx.jar @' \
			-i "${MY_PN}"
	fi
	if use gtk3; then
		sed -r \
			-e '/^exec.*java /s@(bin/java)@\1 -Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dsun.java2d.xrender=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel@' \
			-i "${MY_PN}"
	fi
	default
}

src_install() {
	insinto /usr/share/"${PF}"
	exeinto /usr/share/"${PF}"
	doins -r *
	doexe "${MY_PN}"
	dosym ../../usr/share/"${PF}"/"${MY_PN}" /usr/bin/"${MY_PN}"
	make_desktop_entry "${MY_PN}" "${MY_PN}"
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop wrapper

MY_PN="SweetHome3D"

DESCRIPTION="Sweet Home 3D is a free interior design application."
HOMEPAGE="http://sweethome3d.com/"
SRC_URI="
	amd64? ( mirror://sourceforge/sweethome3d/${MY_PN}-${PV}-linux-x64.tgz )
	x86? ( mirror://sourceforge/sweethome3d/${MY_PN}-${PV}-linux-x86.tgz )
"
LICENSE="GPL-3"
IUSE="gtk3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/jre"

S="${WORKDIR}/${MY_PN}-${PV}"

# QA_PREBUILT="*java3d.*.so"

src_prepare() {
	rm THIRDPARTY-LICENSE-* LICENSE.TXT COPYING.TXT || die
	rm -r lib/java3d-* || die # or maybe remove another ones, and keep it?
	rm -r runtime || die # bundled JRE
	rm "${MY_PN}"{,-Java3D*} || die # upstream-generated wrappers

	# mv "${MY_PN}Icon.png" "${MY_PN}.png"
	default
}

src_install() {
	inst_path="/usr/share/${PF}"
	clp=$(find lib -name '*jar' | xargs | sed -e "s@lib/@${inst_path}/lib/@g" -e "s@ @:@g")
	java_vars=( "\${JAVA_HOME}/bin/java" "\${_JAVA_OPTIONS}" )

	use gtk3 && java_vars+=( "-Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Dsun.java2d.xrender=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel" )

	insinto "${inst_path}"
	doins -r *

	# make_wrapper "${MY_PN}" "${java_vars[*]} -Xmx2g -classpath \"${clp}\" -Djava.library.path=${inst_path}/lib/java3d-1.6 -Djogamp.gluegen.UseTempJarCache=false -Dcom.eteks.sweethome3d.applicationId=SweetHome3D#Installer com.eteks.sweethome3d.SweetHome3D -open"
	make_wrapper "${MY_PN}" "${java_vars[*]} -Xmx2g -classpath \"${clp}\" -Djava.library.path=${inst_path}/lib:${inst_path}/lib/yafaray -Djogamp.gluegen.UseTempJarCache=false -Dcom.eteks.sweethome3d.applicationId=SweetHome3D#Installer com.eteks.sweethome3d.SweetHome3D -open"

	doicon "${MY_PN}Icon.png"

	make_desktop_entry "${MY_PN}" "${MY_PN}" "${MY_PN}"

	# dosym "${PN}" /usr/bin/sweethome3d
}

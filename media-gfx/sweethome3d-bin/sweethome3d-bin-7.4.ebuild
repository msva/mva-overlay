# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop wrapper

MY_PN="SweetHome3D"

DESCRIPTION="Sweet Home 3D is a free interior design application."
HOMEPAGE="https://sweethome3d.com/"
SF_URI="https://downloads.sourceforge.net/${PN//-bin}/${MY_PN}/${MY_PN}-${PV}/${MY_PN}-${PV}-linux"
SRC_URI="
	amd64? ( ${SF_URI}-x64.tgz )
	x86? ( ${SF_URI}-x86.tgz )
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3"

RDEPEND="virtual/jre"

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

	if use gtk3; then
		java_vars+=(
			"-Dawt.useSystemAAFontSettings=gasp"
			"-Dswing.aatext=true"
			"-Dsun.java2d.xrender=true"
			"-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
		)
	fi

	# Only compatible with openjdk>=17 (and also the only way to make it work there)
	# But OTOH, I don't know how to make it compatible with <17 and >=17 at the same time 🤷
	# ref: https://sourceforge.net/p/sweethome3d/bugs/1021/
	java_vars+=( "--add-opens=java.desktop/sun.awt=ALL-UNNAMED" )

	insinto "${inst_path}"
	doins -r *

	make_wrapper "${MY_PN}" "${java_vars[*]} -Xmx2g -classpath \"${clp}\" -Djava.library.path=${inst_path}/lib:${inst_path}/lib/yafaray -Djogamp.gluegen.UseTempJarCache=false -Dcom.eteks.sweethome3d.applicationId=SweetHome3D#Installer com.eteks.sweethome3d.SweetHome3D -open"

	doicon "${MY_PN}Icon.png"

	make_desktop_entry "${MY_PN}" "${MY_PN}" "${MY_PN}"

	# dosym "${PN}" /usr/bin/sweethome3d
}

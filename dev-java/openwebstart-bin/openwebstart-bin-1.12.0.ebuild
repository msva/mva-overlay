# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV//'.'/'_'}

README_GENTOO_SUFFIX="-r1"

inherit unpacker desktop readme.gentoo-r1 xdg-utils

DESCRIPTION="Run Web Start based applications after the release of Java 11"
HOMEPAGE="https://openwebstart.com/"
SRC_URI="https://github.com/karakun/OpenWebStart/releases/download/v${PV}/OpenWebStart_linux_${MY_PV}.deb"

LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.8
"

RESTRICT="bindist mirror strip test"

S="${WORKDIR}"

xxpkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="openjdk-${SLOT} openjdk-bin-${SLOT}"
	JAVA_PKG_WANT_SOURCE="${SLOT}"
	JAVA_PKG_WANT_TARGET="${SLOT}"

	# The nastiness below is necessary while the gentoo-vm USE flag is
	# masked. First we call java-pkg-2_pkg_setup if it looks like the
	# flag was unmasked against one of the possible build VMs. If not,
	# we try finding one of them in their expected locations. This would
	# have been slightly less messy if openjdk-bin had been installed to
	# /opt/${PN}-${SLOT} or if there was a mechanism to install a VM env
	# file but disable it so that it would not normally be selectable.

	local vm
	for vm in ${JAVA_PKG_WANT_BUILD_VM}; do
		if [[ -d ${EPREFIX}/usr/lib/jvm/${vm} ]]; then
			java-pkg-2_pkg_setup
			return
		fi
	done

	if has_version --host-root dev-java/openjdk:${SLOT}; then
		export JAVA_HOME=${EPREFIX}/usr/$(get_libdir)/openjdk-${SLOT}
		export JDK_HOME="${JAVA_HOME}"
		export ANT_RESPECT_JAVA_HOME=true
	else
		if [[ ${MERGE_TYPE} != "binary" ]]; then
			JDK_HOME=$(best_version --host-root dev-java/openjdk-bin:${SLOT})
			[[ -n ${JDK_HOME} ]] || die "Build VM not found!"
			JDK_HOME=${JDK_HOME#*/}
			JDK_HOME=${EPREFIX}/opt/${JDK_HOME%-r*}
			export JDK_HOME
			export JAVA_HOME="${JDK_HOME}"
			export ANT_RESPECT_JAVA_HOME=true
		fi
	fi
}

src_compile() {
	echo binary, no cc
}

src_install() {
	default
	mv "${S}"/opt "${D}"
	mkdir -p "${D}"/usr/share/mime/packages
	cp  "${FILESDIR}/jnlp.xml" "${D}"/usr/share/mime/packages
	newmenu "${FILESDIR}"/itw-settings.desktop openweb-itw-settings.desktop
	newmenu "${FILESDIR}"/javaws.desktop openweb-javaws.desktop
	newicon  "${D}/opt/OpenWebStart/Icon-512.png" openweb-javaws.png
}

pkg_postinst() {
	xdg-icon-resource install --size 512 --context mimetypes "/opt/OpenWebStart/App-Icon-512.png" application-x-java-jnlp-file
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg-icon-resource uninstall --size 512 --context mimetypes application-x-java-jnlp-file
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

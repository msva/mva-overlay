# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

JETTY_V="8.1.14"
JETTY_TS="v20131031"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/i2p/i2p.i2p"
	scm="git-r3"
	KEYWORDS=""
else
	SRC_URI="
		https://download.i2p2.de/releases/${PV}/${PN}source_${PV}.tar.bz2
		http://dist.codehaus.org/jetty/jetty-hightide-${JETTY_V}/jetty-hightide-${JETTY_V}.${JETTY_TS}.zip
	"
	KEYWORDS="~x86 ~amd64"
fi

inherit eutils java-pkg-2 java-ant-2 pax-utils systemd ${scm}

DESCRIPTION="I2P is an anonymous network."
HOMEPAGE="http://www.i2p2.de/"
SLOT="0"
LICENSE="GPL-2"
IUSE=""
DEPEND=">=virtual/jdk-1.5"
RDEPEND="${DEPEND}"

QA_TEXTRELS="opt/i2p/i2psvc opt/i2p/lib/libwrapper.so"
QA_PRESTRIPPED="${QA_TEXTRELS}"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack;
	else
		unpack "i2psource_${PV}.tar.bz2";
		cp "${DISTDIR}/jetty-hightide-${JETTY_V}.${JETTY_TS}.zip" -P "${S}/apps/jetty" || die
	fi
}

src_compile() {
	eant pkg || die
}

src_install() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /opt/i2p/home/ ${PN} -m

	cd pkg-temp || die
	sed -i 's:[%$]INSTALL_PATH:/opt/i2p:g' \
		eepget i2prouter runplain.sh *.config || die
	sed -i 's:[%$]SYSTEM_java_io_tmpdir:/tmp:g' \
		runplain.sh || die
	sed -i 's:wrapper.java.command=java:wrapper.java.command=/etc/java-config-2/current-system-vm/bin/java:' \
	wrapper.config || die
	sed -i 's:^#\?PIDDIR=.*:PIDDIR="/run/":g' \
		i2prouter || die
	sed -i 's:[%$]SYSTEM_java_io_tmpdir:/opt/i2p/home:g' \
		eepget i2prouter *.config || die

# 	Install to package root
	exeinto /opt/i2p
	insinto /opt/i2p

# 	Install files
	doins ${S}/apps/i2psnark/jetty-i2psnark.xml ${S}/pkg-temp/blocklist.txt ${S}/apps/i2psnark/launch-i2psnark ${S}/pkg-temp/hosts.txt || die
	doexe eepget i2prouter ${S}/apps/i2psnark/launch-i2psnark osid postinstall.sh runplain.sh *.config || die

	if use x86; then
		doexe lib/wrapper/linux/i2psvc || die
	elif use amd64; then
		doexe lib/wrapper/linux64/i2psvc || die
	fi

	dodoc history.txt LICENSE.txt INSTALL-headless.txt || die
	doman man/* || die

# 	Install dirs
	doins -r docs geoip eepsite scripts certificates webapps || die
	dodoc -r licenses || die

# 	Install files to package lib
	insinto /opt/i2p/lib
	exeinto /opt/i2p/lib
	find lib/ -maxdepth 1 -type f '!' -name '*.dll' -print0 | xargs -0 doins || die
	if use x86; then
		doexe lib/wrapper/linux/libwrapper.so \
		lib/wrapper.jar || die
	elif use amd64; then
		doexe lib/wrapper/linux64/libwrapper.so \
		lib/wrapper.jar || die
	fi

	dosym "${D}"/opt/i2p/i2prouter /usr/bin/i2prouter
	dosym "${D}"/opt/i2p/eepget /usr/bin/eepget

	newinitd "${FILESDIR}"/i2p.initd i2p
	systemd_dounit "${FILESDIR}"/i2p.service

	pax-mark m "$D/opt/i2p/i2psvc"
}
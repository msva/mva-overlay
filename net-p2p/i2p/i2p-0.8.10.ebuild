# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils java-pkg-2 java-ant-2 pax-utils

JETTY_V="5.1.15"

DESCRIPTION="I2P is an anonymous network."

SRC_URI="http://mirror.i2p2.de/${PN}source_${PV}.tar.bz2
	http://dist.codehaus.org/jetty/jetty-5.1.x/jetty-${JETTY_V}.tgz"
HOMEPAGE="http://www.i2p.net/"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
IUSE="initscript"
DEPEND=">=virtual/jdk-1.5"
RDEPEND="${DEPEND}"

QA_TEXTRELS="opt/i2p/i2psvc"
QA_TEXTRELS="opt/i2p/lib/libwrapper.so"

src_unpack() {
	unpack "i2psource_${PV}.tar.bz2"
	cp "${DISTDIR}/jetty-${JETTY_V}.tgz" -P "${S}/apps/jetty" || die
}

src_compile() {
	eant pkg || die
}

src_install() {
	cd pkg-temp || die
	sed -i 's:[%$]INSTALL_PATH:/opt/i2p:g' \
		eepget i2prouter runplain.sh *.config || die
	sed -i 's:[%$]SYSTEM_java_io_tmpdir:/tmp:g' \
		runplain.sh || die
	if use initscript ; then
		sed -i 's:^#\?PIDDIR=.*:PIDDIR="/var/run/":g' \
			i2prouter || die
		sed -i 's:[%$]SYSTEM_java_io_tmpdir:/opt/i2p/home:g' \
			eepget i2prouter *.config || die
	else
		sed -i 's:[%$]SYSTEM_java_io_tmpdir:/tmp:g' \
			eepget i2prouter *.config || die
	fi
	exeinto /opt/i2p
	insinto /opt/i2p
# 	Install to package root
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
	if use initscript; then
		doinitd "${FILESDIR}"/i2p || die
	fi
	pax-mark m "$D/opt/i2p/i2psvc"
}

pkg_postinst() {
	if use initscript; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /opt/i2p/home/ ${PN} -m
		einfo "Configure the router now : http://localhost:7657/index.jsp"
		einfo "Use /etc/init.d/i2p start to start I2P"
	else
		einfo "Configure the router now : http://localhost:7657/index.jsp"
		einfo "Use 'i2prouter start' to run I2P and 'i2prouter stop' to stop it."
	fi
}

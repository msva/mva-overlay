# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Device-SerialPort/Device-SerialPort-1.40.0.ebuild,v 1.7 2012/12/27 08:47:00 armin76 Exp $

EAPI=5

MODULE_AUTHOR=COSIMO
inherit perl-module

DESCRIPTION="Perl extension to interface GSM phones / modems"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="
	dev-perl/Device-Modem
	dev-perl/Device-SerialPort
"

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

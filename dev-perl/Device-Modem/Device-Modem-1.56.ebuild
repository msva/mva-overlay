# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MODULE_AUTHOR=COSIMO
inherit perl-module

DESCRIPTION="Perl extension to talk to modem devices connected via serial port"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="
	dev-perl/Device-SerialPort
"

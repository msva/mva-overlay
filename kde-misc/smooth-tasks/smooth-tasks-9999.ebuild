# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/smooth-tasks/smooth-tasks-0_p20120130.ebuild,v 1.2 2012/02/01 16:02:36 johu Exp $

EAPI=5

KDE_MINIMAL="4.8"
KDE_LINGUAS="cs de fr hu pl ru zh_CN"
inherit kde4-base mercurial

DESCRIPTION="Alternate taskbar KDE plasmoid, similar to Windows 7"
HOMEPAGE="https://bitbucket.org/flupp/smooth-tasks-fork"

EHG_REPO_URI="https://bitbucket.org/flupp/smooth-tasks-fork"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS=""
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libtaskmanager)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

PATCHES=(
	"${FILESDIR}/${P}-kde48.patch"
)

S="${WORKDIR}/${PN}"

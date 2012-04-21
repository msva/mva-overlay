# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/zen-sources/zen-sources-9999.ebuild,v 1.5 2011/10/17 18:46:00 hwoarang Exp $

EAPI="4"

COMPRESSTYPE=".lzma"
K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE=0
# If these are not set, you will get weird behavior from kernel-2, due to the
# huge $PV that is used otherwise.
CKV='3.99'

ETYPE="sources"

EGIT_REPO_URI="git://zen-kernel.org/kernel/zen-stable.git
	http://git.zen-kernel.org/zen-stable/"

inherit kernel-2 git-2
detect_version

K_NOSETEXTRAVERSION="don't_set_it"
DESCRIPTION="The Zen Kernel Live Sources"
HOMEPAGE="http://zen-kernel.org"

IUSE="+minimal"

KEYWORDS=""

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on freenode"

pkg_setup(){
	ewarn "Be carefull!! You are about to install live kernel sources."
	ewarn "Git zen-sources are extremely unsupported, even from the upstream"
	ewarn "developers. Use them at your own risk and don't bite us if your"
	ewarn "system explodes"
	if use minimal; then
		EGIT_OPTIONS="--depth 1"
		EGIT_NONBARE="1"
	fi
	kernel-2_pkg_setup
}

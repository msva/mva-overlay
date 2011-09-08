# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

IUSE=""

inherit kernel-2 git-2
detect_version

K_NOSETEXTRAVERSION="don't_set_it"
DESCRIPTION="The Zen Kernel Live Sources"
HOMEPAGE="http://zen-kernel.org"

EGIT_FETCH_CMD="${EGIT_FETCH_CMD} --depth 1"
EGIT_REPO_URI="git://zen-kernel.org/kernel/zen-stable.git"

KEYWORDS=""

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on irc.rizon.net"

pkg_setup(){
	ewarn "Be carefull!! You are about to install live kernel sources."
	ewarn "Git zen-sources are extremely unsupported, even from the upstream"
	ewarn "developers. Use them at your own risk and don't bite us if your"
	ewarn "system explodes"
	ebeep 10
	kernel-2_pkg_setup
}

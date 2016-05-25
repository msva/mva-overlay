# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit savedconfig git-r3

SRC_URI=""
EGIT_REPO_URI="https://github.com/kvalo/ath10k-firmware"
KEYWORDS=""

DESCRIPTION="Atheros ath10k firmware files"
HOMEPAGE="https://github.com/kvalo/ath10k-firmware"

LICENSE="qca-firmware"
SLOT="0"
IUSE="savedconfig"

DEPEND=""
RDEPEND=""

LF_COLLISION=()
LF_COLLISION+=("QCA6174/hw3.0/board-2.bin")
LF_COLLISION+=("QCA6174/hw2.1/board-2.bin")
LF_COLLISION+=("QCA9377/hw1.0/board-2.bin")
LF_COLLISION+=("QCA9377/hw1.0/board.bin")

src_prepare() {
	echo "# Remove files that shall not be installed from this list." > ${PN}.conf
	find * \( \! -type d -and \! -name ${PN}.conf \) >> ${PN}.conf

	if use savedconfig; then
		restore_config ${PN}.conf
		ebegin "Removing all files not listed in config"
		find * \( \! -type d -and \! -name ${PN}.conf \) \
			| sort ${PN}.conf ${PN}.conf - \
			| uniq -u | xargs -r rm
		eend $? || die
		# remove empty directories, bug #396073
		find -type d -empty -delete || die
	else
		for f in ${LF_COLLISION[@]}; do
			rm -f ${f};
		done
	fi

	rm Makefile LICENSE.qca_firmware README.md
}

src_install() {
	save_config ${PN}.conf
	rm ${PN}.conf || die
	insinto /lib/firmware/ath10k
	doins -r *
}

pkg_preinst() {
	if use savedconfig; then
		ewarn "USE=savedconfig is active. You must handle file collisions manually."
	fi
}

pkg_postinst() {
	elog "If you are only interested in particular firmware files, edit the saved"
	elog "configfile and remove those that you do not want."
}

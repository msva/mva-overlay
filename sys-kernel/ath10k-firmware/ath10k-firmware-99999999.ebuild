# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit savedconfig git-r3

SRC_URI=""
EGIT_REPO_URI="https://github.com/kvalo/ath10k-firmware"
KEYWORDS=""

DESCRIPTION="Atheros ath10k firmware files"
HOMEPAGE="https://github.com/kvalo/ath10k-firmware"

LICENSE="qca-firmware"
SLOT="0"
IUSE="savedconfig"

RDEPEND="sys-kernel/linux-firmware"
DEPEND="sys-apps/coreutils"

#LF_COLLISION=()
#LF_COLLISION+=("QCA6174/hw3.0/board-2.bin")
#LF_COLLISION+=("QCA6174/hw2.1/board-2.bin")
#LF_COLLISION+=("QCA9377/hw1.0/board-2.bin")
#LF_COLLISION+=("QCA9377/hw1.0/board.bin")
#LF_COLLISION+=("QCA988X/hw2.0/board.bin")

get_hash() {
	sha1sum -b "${1}" | cut -f1 -d' '
}

is_identical() {
	test $(get_hash ${1}) == $(get_hash ${2})
}

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
	else
		find . -type f -wholename './QCA*' |
		while read f; do
#		for f in ${LF_COLLISION[@]}; do
			test -e "/lib/firmware/ath10k/${f}" && {
				is_identical "/lib/firmware/ath10k/${f}" "${f}" ||
				echo "${f}" >> "${T}/.collisions";
				rm -f "${f}"
			}
		done
	fi

	# remove empty directories, bug #396073
	find -type d -empty -delete || die
	rm -f Makefile LICENSE.qca_firmware README.md
	default
}

src_install() {
	save_config ${PN}.conf
	rm ${PN}.conf || die
	insinto /lib/firmware/ath10k
	doins -r *
}

pkg_preinst() {
	if ! use savedconfig && test -e "${T}/.collisions"; then
		ewarn "USE=savedconfig is not active, but there are existing collisions with sys-kernel/linux-firmware found (and files are differ)."
		ewarn "You must enable USE=savedconfig here and for sys-kernel/linux-firmware and handle file collisions manually."
		ewarn "Collided files:"
		while read f; do
			eerror "\t\t${f}"
		done < "${T}/.collisions"
		ewarn "Collided files was not installed, so consider to follow instructions above if you need them."
	fi
	if use savedconfig; then
		ewarn "USE=savedconfig is active. You must handle file collisions manually."
	fi
}

pkg_postinst() {
	elog "If you are only interested in particular firmware files, edit the saved"
	elog "configfile and remove those that you do not want."
}

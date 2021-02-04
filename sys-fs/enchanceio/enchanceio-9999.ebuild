# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils git-r3 linux-info linux-mod

DESCRIPTION="SSD caching software, based on Facebook's open source Flashcache project"
HOMEPAGE="https://github.com/stec-inc/EnhanceIO"
EGIT_REPO_URI="https://github.com/stec-inc/EnhanceIO.git"
ETYPE="sources"

LICENSE="GPL-2"
SLOT="0"

IUSE="doc"

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

#CONFIG_CHECK="MD BLK_DEV_DM DM_UEVENT"

BUILD_TARGETS=" "
MODULE_NAMES="enhanceio(extra:Driver/enhanceio) enhanceio_lru(extra:Driver/enhanceio) enhanceio_fifo(extra:Driver/enhanceio) enhanceio_rand(extra:Driver/enhanceio)"

src_prepare() {
	# buildsystem fix
	sed -i -r \
	-e 's#make#$(MAKE)#g' \
	Driver/enhanceio/Makefile
	# ^ jobsrver unavailable, -j1

	default
}

src_compile() {
	set_arch_to_kernel
	pushd Driver/enhanceio &>/dev/null
	linux-mod_src_compile
	popd &>/dev/null
}

src_install() {
	linux-mod_src_install
	dosbin CLI/eio_cli
	doman CLI/eio_cli.8
}

pkg_postinst() {
	ewarn
	ewarn "EnhanceIO caches are persistent by default. A udev rule file named"
	ewarn "94-enhanceio-<cache_name>.rules is created, removed by create, delete"
	ewarn "sub-commands in eio_cli. "
	ewarn
	ewarn "NOTE: Creating a writeback cache on root device is not supported."
	ewarn "This is because the root device is mounted as read only prior to "
	ewarn "the processing of udev rules."
	ewarn
	ewarn "Make sure you've added \"enhanceio_lru enhanceio_fifo enhanceio_rand enhanceio\" "
	ewarn "to your /etc/conf.d/modules in order to load enhanceio at the boot."
}

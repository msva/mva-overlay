# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 patches

DESCRIPTION="process reaper intended for use as init-system in app-emulation/firejail"
HOMEPAGE="https://github.com/ScoreUnder/fjinit"
EGIT_REPO_URI="https://github.com/ScoreUnder/${PN}"

LICENSE="MIT"
SLOT="0"

src_prepare() {
	sed -r \
		-e 's#^(PREFIX).*#\1=/usr#' \
		-e "s#^(CFLAGS.*)-Os#\1 ${CFLAGS}#" \
		-e 's#^(LDFLAGS.*)-s#\1#' \
		-i config.mk
	patches_src_prepare
}

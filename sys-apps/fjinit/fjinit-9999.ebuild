# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

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

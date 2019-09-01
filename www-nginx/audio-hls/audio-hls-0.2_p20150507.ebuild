# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_aac_module.so")

GITHUB_A="flavioribeiro"
GITHUB_PN="nginx-audio-track-for-hls-module"
GITHUB_SHA="84f79f70ac9752deb263d777308e9d667ae34e57"

inherit nginx-module

DESCRIPTION="Generates audio track for HTTP Live Streaming (HLS) streams on the fly."
HOMEPAGE="https://github.com/flavioribeiro/nginx-audio-track-for-hls-module"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	app-arch/bzip2
	virtual/ffmpeg
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,nginx.conf} )

nginx-module-prepare() {
	# FIXME: when dyn-mod PR will be merged
	rm config &&
	cp "${FILESDIR}/config.dyn" config
}

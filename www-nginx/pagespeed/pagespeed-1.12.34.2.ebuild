# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

beta="${PV/*_beta*}"
beta="${beta:+stable}"
beta="${beta:-beta}"

NG_MOD_LIST=("ngx_pagespeed.so")
NG_MOD_SUFFIX="-${beta}"

GITHUB_A="${PN}"
GITHUB_PN="ngx_${PN}"
GITHUB_PV="v${PV}${NG_MOD_SUFFIX}"

inherit nginx-module

DESCRIPTION="PageSpeed dynamic module for NginX"
HOMEPAGE="https://github.com/pagespeed/ngx_pagespeed"

#SRC_URI="
#	https://github.com/pagespeed/ngx_pagespeed/archive/v${PV}${NG_MOD_SUFFIX}.tar.gz -> ${P}-nginx.tar.gz
#	https://github.com/pagespeed/mod_pagespeed/archive/${PV}.tar.gz -> ${P}-apache.tar.gz
#"
PSOL_URI="https://dl.google.com/dl/page-speed/psol/${PV}-__ARCH__.tar.gz"
SRC_URI="
	${SRC_URI}
	x86? ( ${PSOL_URI/__ARCH__/ia32} -> ${P}.psol.x86.tar.gz )
	amd64? ( ${PSOL_URI/__ARCH__/x64} -> ${P}.psol.amd64.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[pcre]
"
#	dev-util/depot_tools
#	dev-lang/python:2.7
#"
#	www-apache/pagespeed ?
# TODO: try to unbundle jsoncpp

RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{README.md,test/{valgrind.sup,pagespeed_test.conf.template}} )

#nginx-module-unpack() {
#	git-r3_src_unpack
#	(
#		EGIT_REPO_URI="https://github.com/pagespeed/mod_pagespeed"
#		EGIT_COMMIT="${PV}"
#		git-r3_src_unpack
#	)
#}

nginx-module-setup() {
	ewarn "${CATEGORY}/${P} is known to have 'RWX' stack QA issues."
	ewarn "It happens because of using precompiled static PSOL library,"
	ewarn "which Google guys built in that bad way."
	ewarn ""
	ewarn "So, you'll definitelly get QA warning on install phase."
	ewarn "If you'll be about to report it — report it to ${HOMEPAGE},"
	ewarn "but not against the ebuild, please."
	ewarn ""
	ewarn "P.S.: alternative way (build PSOL from source) would require:"
	ewarn "Apache parts, chromium parts, python magic and many many more."
}

nginx-module-prepare() {
	ln -sTf ../psol ./psol
}

#	export MOD_PAGESPEED_DIR="${WORKDIR}/mod_${P}/src"
#	einfo "Preparing pagespeed optimisation library"
#	pushd "${WORKDIR}/mod_${P}" &>/dev/null
#		python2 build/gyp_chromium --depth=.
#		emake BUILDTYPE=Release mod_pagespeed_test pagespeed_automatic_test
#		exit
#	popd &>/dev/null
#
#	einfo "Patching the module (if needed)"

nginx-module-configure() {
	myconf+=("--with-http_ssl_module" "--with-pcre")
}

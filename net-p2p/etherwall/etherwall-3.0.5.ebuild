# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Qt5 Etherium Wallet"
HOMEPAGE="https://github.com/almindor/etherwall"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/almindor/${PN}"
else
	EW_NODE_SHA=dcc3d76f833a9be47a094e46a0ffa7503e28d007
	TREZOR_COMMON_SHA=db106e8f2766155bc72802e4dc3f9f59c90d9c3e
	TREZOR_COMMON_URI="https://github.com/trezor/trezor-common/archive/${TREZOR_COMMON_SHA}.tar.gz"
	SRC_URI="
		https://github.com/almindor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/almindor/ew-node/archive/${EW_NODE_SHA}.tar.gz -> ew-node-${EW_NODE_SHA}.tar.gz
		${TREZOR_COMMON_URI} -> trezor-common-${TREZOR_COMMON_SHA}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
LICENSE="BSD"
SLOT="0"

BDEPEND="
	${BDEPEND}
	dev-libs/protobuf
"

src_prepare() {
	default
	sed -r \
		-e 's@/opt/\$\$\{TARGET\}@/usr@' \
		-i "${S}/deployment.pri" || die 'Failed to patch install path'
	rmdir "${S}/src/ew-node" "${S}/src/trezor/trezor-common"
	mv "${WORKDIR}/ew-node-${EW_NODE_SHA}" "${S}/src/ew-node/" || die "Failed to move ew-node"
	mv "${WORKDIR}/trezor-common-${TREZOR_COMMON_SHA}" "${S}/src/trezor/trezor-common" \
		|| die "Failed to move trezor-common"
	./generate_protobuf.sh || die "Failed to regen protobuf"
}

src_configure(){
#	local myeqmakeargs=()
	eqmake5 ${myeqmakeargs[@]}
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die
}

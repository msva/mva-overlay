# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..12} )

inherit cmake python-r1

DESCRIPTION="A lightweight C++11 Distributed Hash Table implementation"
HOMEPAGE="https://github.com/savoirfairelinux/opendht"

if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/savoirfairelinux/${PN}"
else
	SRC_URI="https://github.com/savoirfairelinux/opendht/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"

SLOT="0"

IUSE="doc dht-index http-client proxy-client proxy-server proxy-server-identity proxy-openssl push-notifications python static-libs tools"

DEPEND="
	dev-libs/msgpack
	net-libs/gnutls
	python? ( dev-python/cython[${PYTHON_USEDEP}] )
	tools? ( sys-libs/readline:0 )
	proxy-openssl? ( dev-libs/openssl:= )
	doc? ( app-text/doxygen )
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="http-client? ( !proxy-server !proxy-client ) ${PYTHON_REQUIRED_USE}"

src_configure() {
	local mycmakeargs=(
		-DOPENDHT_PYTHON=$(usex python)
		-DOPENDHT_STATIC=$(usex static-libs)
		-DOPENDHT_TOOLS=$(usex tools)
		-DOPENDHT_SHARED=ON
		-DOPENDHT_LOG=ON
		-DOPENDHT_SYSTEMD=ON
		-DOPENDHT_HTTP=$(usex http-client)
		-DOPENDHT_INDEX=$(usex dht-index)
		-DOPENDHT_PEER_DISCOVERY=ON
		-DOPENDHT_PROXY_SERVER=$(usex proxy-server)
		-DOPENDHT_PROXY_SERVER_IDENTITY=$(usex proxy-server-identity)
		-DOPENDHT_PROXY_CLIENT=$(usex proxy-client)
		-DOPENDHT_PROXY_OPENSSL=$(usex proxy-openssl)
		-DOPENDHT_PUSH_NOTIFICATIONS=$(usex push-notifications)
		-DOPENDHT_SANITIZE=OFF
		-DOPENDHT_TESTS=OFF
		-DOPENDHT_TESTS_NETWORK=OFF
		-DOPENDHT_C=ON
		-DOPENDHT_DOCUMENTATION=$(usex doc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}

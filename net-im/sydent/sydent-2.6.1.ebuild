# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{9..14} )

inherit distutils-r1

DESCRIPTION="Reference Matrix Identity Verification and Lookup Server"
HOMEPAGE="https://matrix.org/"

SRC_URI="https://github.com/matrix-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gammu"

distutils_enable_tests pytest

RDEPEND="
	acct-user/sydent
	acct-group/sydent
	>=dev-python/attrs-19.1.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.1.0[${PYTHON_USEDEP}]
	<dev-python/matrix-common-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/phonenumbers-8.12.32[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/service-identity-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/signedjson-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	>=dev-python/unpaddedbase64-1.1.0[${PYTHON_USEDEP}]
	gammu? ( dev-python/python-gammu[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	distutils-r1_src_prepare
	use gammu && eapply "${FILESDIR}/03_local_gammu_sms.patch"
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	cd "${S}" && python -c 'from sydent.sydent import *; SydentConfig().parse_config_file(get_config_file_path())'
	sed -i 's:res:/etc/sydent/templates/<brand.default>:g' "${S}/sydent.conf"
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
	newinitd "${FILESDIR}/sydent.initd" sydent
	insinto /etc/sydent
	newins "${S}/sydent.conf" sydent.conf.example
	insinto /etc/sydent/templates
	doins -r "${S}/res/matrix-org"
}

pkg_preinst() {
	keepdir /var/lib/sydent /var/run/sydent
	fowners sydent:sydent /var/lib/sydent /var/run/sydent
}
pkg_postinst() {
	if [ ! -e /etc/sydent/sydent.conf ]; then
		elog
		elog "Please cp /etc/sydent/sydent.conf.example /etc/sydent/sydent.conf"
		elog "And tune it to your needs"
		elog "Note that all of keys of config, as it may seem, should be transferred"
	elog "from DEFAULT to other relevant section of config (strange idea, yes?)"
		elog
		elog "Also please cp /etc/sydent/templates/matrix-org/* /etc/sydent/templates/<brand.default>/"
		elog "And tune them to your needs (brand.default being set in sydent.conf and need substitution)"
		elog
	else
		elog
		elog "May be it is good idea to compare working config with example one"
		elog "diff /etc/sydent/sydent.conf.example /etc/sydent/sydent.conf"
		elog
	fi
}

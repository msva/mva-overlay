# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

RUBY_OPTIONAL="yes"
USE_RUBY="ruby24 ruby25 ruby26"

PHP_EXT_INI="no"
PHP_EXT_NAME="dummy"
PHP_EXT_OPTIONAL_USE="unit_modules_php"
PHP_EXT_NEEDED_USE="embed"
USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit systemd php-ext-source-r3 python-r1 ruby-ng flag-o-matic

DESCRIPTION="Dynamic web and application server"
HOMEPAGE="https://unit.nginx.org/"

MY_P="${P//nginx-}"
SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"

UNIT_MODULES="perl php python ruby"
IUSE="debug examples ipv6 ssl +unix-sockets ${UNIT_MODULES}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

for mod in $UNIT_MODULES; do
	IUSE="${IUSE} unit_modules_${mod}"
	REQUIRED_USE="${REQUIRED_USE} ${mod}? ( unit_modules_${mod} )"
done

DEPEND="
	unit_modules_perl? (
		dev-lang/perl:=
	)
	unit_modules_python? (
		${PYTHON_DEPS}
	)
	unit_modules_ruby? (
		$(ruby_implementations_depend)
	)
	ssl? (
		dev-libs/openssl:0=
	)
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/auto-make.patch"
	"${FILESDIR}/auto-os-conf.patch"
)

src_unpack() {
	# prevent ruby-ng
	default
}

src_prepare() {
	sed -r \
		-e 's@-Werror@@g' \
		-i auto/cc/test
	default
	tc-env_build
}

_unit_perl_configure() {
	./configure perl # multislot?
}
_unit_php_configure() {
	for impl in $(php_get_slots); do
		./configure php --config="/usr/$(get_libdir)/${impl}/bin/php-config" --module="${impl/.}" --lib-path="/usr/lib/${impl}/$(get_libdir)"
	done
}
_unit_python_configure() {
	_unit_python_configure_each() {
		./configure python --config="${EPYTHON}-config" --module="${EPYTHON/.}"
	}
	python_foreach_impl _unit_python_configure_each
}
_unit_ruby_configure() {
	_unit_ruby_configure_each() {
		cd "${WORKDIR}/${MY_P}"
		./configure ruby --ruby="${RUBY}" --module="$(basename ${RUBY})"
	}
	_ruby_each_implementation _unit_ruby_configure_each
}

src_configure() {
	./configure \
		--cc="${CC}" \
		--cc-opt="${CFLAGS}" \
		--ld-opt="${LDFLAGS}" \
		--bindir="/usr/bin" \
		--sbindir="/usr/sbin" \
		--prefix="/var/lib/${PN}" \
		--modules="/usr/lib/${PN}/modules" \
		--state="/var/lib/${PN}" \
		--pid="/run/${PN}.pid" \
		--log="/var/log/${PN}.log" \
		$(usex ipv6 '' "--no-ipv6") \
		$(usex unix-sockets "--control=unix:/run/${PN}.sock" "--no-unix-sockets") \
		$(usex ssl "--openssl" "") \
		$(usex debug "--debug" "")

	for mod in $UNIT_MODULES; do
		use "unit_modules_${mod}" && "_unit_${mod}_configure"
	done
}

src_compile() {
	# Prevent ruby-ng, and also force to use "all" target
	emake all
}

src_install() {
	default
	diropts -m 0770
	keepdir /var/lib/"${PN}"
	dobin "${FILESDIR}"/util/"${PN}"-{save,load}config
	systemd_dounit "${FILESDIR}"/init/"${PN}".service
	newconfd "${FILESDIR}"/init/"${PN}".confd "${PN}"
	newinitd "${FILESDIR}"/init/"${PN}".initd "${PN}"
	dodir "/etc/${PN}/"
	insinto "/etc/${PN}/"
	newins "${FILESDIR}/config/config.json" "config.json"
}

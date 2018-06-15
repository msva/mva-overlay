# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

RUBY_OPTIONAL="yes"
USE_RUBY="ruby22 ruby23 ruby24"

PHP_EXT_INI="no"
PHP_EXT_NAME="dummy"
PHP_EXT_OPTIONAL_USE="unit_modules_php"
PHP_EXT_NEEDED_USE="embed"
USE_PHP="php5-6 php7-0 php7-1 php7-2" # deps must be registered separately below

[[ "${PV}" = 9999 ]] && vcs=git-r3

inherit golang-base systemd user php-ext-source-r3 python-r1 ruby-ng flag-o-matic ${vcs}

DESCRIPTION="A dynamic web&application server with modules many languages"
HOMEPAGE="https://unit.nginx.org/"

if [[ "${PV}" = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/nginx/unit"
	KEYWORDS=""
else
	SRC_URI="https://unit.nginx.org/download/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64 ~arm ~arm64"
fi

LICENSE="Apache-2.0"
SLOT="0"

IUSE="+ipv6 +unix-sockets debug examples"
UNIT_MODULES="go perl php python ruby"

for mod in $UNIT_MODULES; do
	IUSE="${IUSE} +unit_modules_${mod}"
done

DEPEND="
	${DEPEND}
	unit_modules_go? (
		dev-lang/go
	)
	unit_modules_perl? (
		dev-lang/perl
	)
	unit_modules_python? (
		${PYTHON_DEPS}
	)
	unit_modules_ruby? (
		$(ruby_implementations_depend)
	)
"
RDEPEND="${DEPEND} ${RDEPEND}"

MY_P="${P}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	# prevent ruby-ng
	if [[ "${PV}" == 9999 ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	default
	tc-env_build
}

_unit_go_configure() {
	./configure go --go-path="$(get_golibdir_gopath)" # multislot?
}

_unit_perl_configure() {
	./configure perl # multislot?
}
_unit_php_configure() {
	for impl in $(php_get_slots); do
		./configure php --config="/usr/lib64/${impl}/bin/php-config" --module="${impl/.}" --lib-path="/usr/lib/${impl}/lib64"
	done
}
_unit_python_configure() {
	_unit_python_configure_each() {
		./configure python --config="${EPYTHON}-config" --module="${EPYTHON/.}"
	}
	python_foreach_impl _unit_python_configure_each
}
_unit_ruby_configure() {
	_ruby_each_implementation_each() {
		cd "${WORKDIR}/${MY_P}"
		./configure ruby --ruby="${RUBY}" --module="$(basename ${RUBY})"
	}
	_ruby_each_implementation _ruby_each_implementation_each
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
		--control="unix:/run/control.${PN}.sock" \
		$(usex ipv6 '' "--no-ipv6")
		$(usex unix-sockets '' "--no-unix-sockets")
		$(usex debug "debug" "")

	for mod in $UNIT_MODULES; do
		use "unit_modules_${mod}" && "_unit_${mod}_configure"
	done
}

src_compile() {
	emake all
}

src_install() {
	default
	use examples && {
		local exdir="ecompressdir --ignore /usr/share/doc/${PF}/examples"
		"ecompressdir" --ignore "${exdir}"
		insinto "${exdir}"
		doins pkg/rpm/rpmbuild/SOURCES/*example*
	}
	keepdir /var/lib/"${PN}"
	dobin "${FILESDIR}"/util/unit-{save,load}config
	systemd_dounit "${FILESDIR}"/init/"${PN}".service
	newconfd "${FILESDIR}"/init/"${PN}".confd "${PN}"
	newinitd "${FILESDIR}"/init/"${PN}".initd "${PN}"
}

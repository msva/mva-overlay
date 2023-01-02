# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

RUBY_OPTIONAL="yes"
USE_RUBY="ruby27 ruby30 ruby31"

PHP_EXT_INI="no"
PHP_EXT_NAME="dummy"
PHP_EXT_OPTIONAL_USE="unit_modules_php"
PHP_EXT_NEEDED_USE="embed"
USE_PHP="php7-4 php8-0 php8-1"

inherit systemd php-ext-source-r3 python-r1 ruby-ng toolchain-funcs flag-o-matic patches
# golang-base

DESCRIPTION="Dynamic web and application server"
HOMEPAGE="https://unit.nginx.org/"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/nginx/unit"
	MY_P="${P}"
	inherit git-r3
else
	MY_P="${P//nginx-}"
	SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

UNIT_MODULES="perl php python ruby"
# go java nodejs
# ^ not needed, as can (and should) be installed with language package managers as vendored dependency while building application.
IUSE="debug examples ipv6 ssl +unix-sockets"

for mod in $UNIT_MODULES; do
	IUSE="${IUSE} unit_modules_${mod}"
done

REQUIRED_USE="unit_modules_python? ( ${PYTHON_REQUIRED_USE} )"

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
#	unit_modules_go? (
#		dev-lang/go:*
#	)
#	unit_modules_nodejs? (
#		net-libs/nodejs:*
#	)
#	unit_modules_java? (
#		virtual/jre:*
#	)
RDEPEND="${DEPEND}"
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
	sed -r \
		-e 's@-Werror@@g' \
		-i auto/cc/test

	sed -i '/^CFLAGS/d' auto/make || die

	patches_src_prepare
	tc-export_build_env
}

_unit_java_configure() {
	unset _JAVA_OPTIONS # breaks the build if defined
	./configure java --home="${NGINX_UNIT_JAVA_HOME:-/etc/java-config-2/current-system-vm}" # multislot?
	# ^ if we will use just ${JAVA_HOME}, then it will be the same result
	# as if we called it without the --home (it takes that by itself)
	# Also, JAVA_HOME can be inherited from user's environment (so,
	# user-vm will be used instead of system-vm).
	# That's why I decided to manually set system-vm, but still
	# give user a way to specify exact the vm they want.
}
_unit_go_configure() {
	# ./configure go --go-path="$(get_golibdir_gopath)" # deprecated golang-base eclass
	./configure go --go-path="${EPREFIX}/usr/lib/go" # multislot?
}
_unit_nodejs_configure() {
	./configure nodejs --node-gyp="/usr/$(get_libdir)/node_modules/npm/bin/node-gyp-bin/node-gyp"
}
_unit_perl_configure() {
	./configure perl
}
_unit_php_configure() {
	for impl in $(php_get_slots); do
		./configure php --config="/usr/$(get_libdir)/${impl}/bin/php-config" --module="${impl/.}" --lib-path="/usr/$(get_libdir)/${impl}/$(get_libdir)" || die "Failed to configure PHP module for ${impl} target"
	done
}
_unit_python_configure() {
	_unit_python_configure_each() {
		./configure python --config="${EPYTHON}-config" --module="${EPYTHON/.}"
	}
	python_foreach_impl _unit_python_configure_each
}
_unit_ruby_configure() {
	each_ruby_configure() {
		cd "${WORKDIR}/${MY_P}"
		./configure ruby --ruby="${RUBY}" --module="$(basename ${RUBY})"
	}
	ruby-ng_src_configure
}

src_configure() {
	append-cflags $(test-flags-CC -fPIC)
	./configure \
		--cc="${CC}" \
		--cc-opt="${CFLAGS}" \
		--ld-opt="${LDFLAGS}" \
		--prefix="/usr" \
		--modules="$(get_libdir)/${PN}" \
		--state="/var/lib/${PN}" \
		--tmp="/tmp" \
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
	emake DESTDIR="${D}" install libunit-install
	diropts -m 0770
	keepdir /var/lib/"${PN}"
	dobin "${FILESDIR}"/util/"${PN}"-{save,load}config
	systemd_dounit "${FILESDIR}"/init/"${PN}".service
	newconfd "${FILESDIR}"/init/"${PN}".confd "${PN}"
	newinitd "${FILESDIR}"/init/"${PN}".initd "${PN}"
	insinto "/etc/${PN}/"
	dodir "/etc/${PN}/"
	newins "${FILESDIR}/config/config.json" "config.json"
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils systemd flag-o-matic linux-info pam user

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/libcg/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+daemon elibc_musl debug pam static-libs systemd +tools"

RDEPEND="pam? ( virtual/pam )"

DEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	elibc_musl? ( sys-libs/fts-standalone )
	"
REQUIRED_USE="daemon? ( tools )"

DOCS=(README_daemon README README_systemd INSTALL)
pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
		enewgroup cgred 160
	fi
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-replace_DECLS.patch
	epatch "${FILESDIR}"/${P}-replace_INLCUDES.patch
	epatch "${FILESDIR}"/${P}-reorder-headers.patch

	# Change rules file location
	sed -e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-i samples/cgred.conf || die "sed failed"
	sed \
		-e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-e 's:/etc/cgconfig.conf:/etc/cgroup/cgconfig.conf:' \
		-i src/libcgroup-internal.h || die "sed failed"
	sed \
		-e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-e 's:/etc/cgconfig.conf:/etc/cgroup/cgconfig.conf:' \
		-i doc/man/*.* README_systemd || die "sed failed"
	sed -e 's:\(pam_cgroup_la_LDFLAGS.*\):\1\ -avoid-version:' \
		-i src/pam/Makefile.am || die "sed failed"
	sed -e 's#/var/run#/run#g' -i configure.in || die "sed failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=()

	if use daemon; then
		myeconfargs+=("--enable-cgred-socket=/run/cgred.socket")
	fi

	if use systemd; then
		myeconfargs+=("--enable-opaque-hierarchy=name=systemd")
	fi

	if use pam; then
		myeconfargs+=("--enable-pam-module-dir=$(getpam_mod_dir)")
	fi

	if use debug; then
		myeconfargs+=("--enable-debug")
		replace-flags "-O*" "-O0"
		append-flags "-ggdb -DDEBUG"
	fi

	use elibc_musl && append-ldflags "-lfts"

	econf \
		$(use_enable static-libs static) \
		$(use_enable daemon) \
		$(use_enable pam) \
		$(use_enable tools) \
		${myeconfargs[@]}
}

src_test() {
	# Use mount cgroup to build directory
	# sandbox restricted to trivial build,
	# possible kill Diego tanderbox ;)
	true
}

src_install() {
	default
	prune_libtool_files --all

	insinto /etc/cgroup
	doins samples/*.conf || die

	if use tools; then
		newconfd "${FILESDIR}"/cgconfig.confd-r1 cgconfig || die
		newinitd "${FILESDIR}"/cgconfig.initd-r1 cgconfig || die
		systemd_dounit "${FILESDIR}"/cgconfig.service  || die
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd-r1 cgred || die
		newinitd "${FILESDIR}"/cgred.initd-r1 cgred || die
		systemd_dounit "${FILESDIR}"/cgrules.service || die
		systemd_dounit "${FILESDIR}"/cgrules.socket  || die
	fi
}

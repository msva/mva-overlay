# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build systemd

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"

LICENSE="BSD"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keybase/client.git"
else
	SRC_URI="https://github.com/keybase/client/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="browser gui +kbfs"

RESTRICT="gui? ( network-sandbox )"

BDEPEND="
	gui? ( sys-apps/yarn )
	kbfs? (
		!app-crypt/kbfs
		sys-fs/fuse
	)
"
RDEPEND="app-crypt/gnupg"

src_unpack() {
	unpack "${P}.tar.gz"
	ln -vs "client-${PV}" "${P}" || die
	mkdir -vp "${S}/src/github.com/keybase" || die
	ln -vs "${S}" "${S}/src/github.com/keybase/client" || die
}

src_compile() {
	EGO_PN="github.com/keybase/client/go/keybase" \
	EGO_BUILD_FLAGS="-tags production -o ${T}/keybase" \
		golang-build_src_compile
	use browser && (
		EGO_PN="github.com/keybase/client/go/kbnm" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/kbnm" \
			golang-build_src_compile
	)
	use kbfs && (
		EGO_PN="github.com/keybase/client/go/kbfs/kbfsfuse" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/kbfsfuse" \
			golang-build_src_compile
		EGO_PN="github.com/keybase/client/go/kbfs/kbfsgit/git-remote-keybase" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/git-remote-keybase" \
			golang-build_src_compile
		EGO_PN="github.com/keybase/client/go/kbfs/redirector" \
		EGO_BUILD_FLAGS="-tags production -o ${T}/keybase-redirector" \
			golang-build_src_compile
	)
	use gui && (
		local arch
		use x86 && arch="ia32"
		use amd64 && arch="x64"
		cd shared
		yarn
		yarn run package -- --platform linux --arch "${arch}" --appVersion "${PV}"
	)
}

src_test() {
	EGO_PN="github.com/keybase/client/go/keybase" \
		golang-build_src_test
}

src_install() {
	dobin "${T}/keybase"
	dobin "${S}/packaging/linux/run_keybase"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase.service"
	dodir "/opt/keybase"
	insinto "/opt/keybase"
	doins "${S}/packaging/linux/crypto_squirrel.txt"

	use gui && (
		local arch
		use x86 && arch="ia32"
		use amd64 && arch="x64"

		cd shared/desktop/release/linux-${arch}/Keybase-linux-${arch}
		rm libGLESv2.so libEGL.so
		insinto "/opt/keybase"
		exeinto "/opt/keybase"
		doins -r *
		doexe chrome-sandbox Keybase

		systemd_douserunit "${S}/packaging/linux/systemd/keybase.gui.service"
	)

	use browser && {
		dobin "${T}/kbnm"
		KBNM_INSTALL_ROOT=1 KBNM_INSTALL_OVERLAY="${D}" "${D}/usr/bin/kbnm" install
	}

	use kbfs && {
		dobin "${T}/kbfsfuse" "${T}/git-remote-keybase" "${T}/keybase-redirector"
		systemd_douserunit "${S}/packaging/linux/systemd/kbfs.service"
		systemd_douserunit "${S}/packaging/linux/systemd/keybase-redirector.service"
	}
}

pkg_postinst() {
	elog "Start/Restart keybase: run_keybase"
	elog "Run the service:       keybase service"
	elog "Run the client:        keybase login"
	ewarn "Note that the user keybasehelper is obsolete and can be removed"
}

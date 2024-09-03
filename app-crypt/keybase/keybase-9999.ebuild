# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Keybase client"
HOMEPAGE="https://keybase.io/"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/keybase/client.git"
	inherit git-r3
else
	MY_PACKAGER=nicolasbock
	SRC_URI="https://github.com/keybase/client/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~${MY_PACKAGER}/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="0"

IUSE="browser gui +kbfs +system-libglvnd system-ffmpeg +system-vulkan"

RESTRICT="gui? ( network-sandbox )"

BDEPEND="
	gui? (
		sys-apps/yarn
		net-libs/nodejs
	)
	kbfs? (
		sys-fs/fuse
	)
"
RDEPEND="
	app-crypt/gnupg
	gui? (
		!system-vulkan? ( media-libs/vulkan-loader )
		!system-ffmpeg? ( media-video/ffmpeg )
		!system-libglvnd? ( media-libs/libglvnd )
	)
"

src_unpack() {
	default
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		# go-module_live_vendor
		GOMODCACHE="${S}/go/go-mod"
		pushd "${S}/go" || die
		ego mod download
		popd || die
	else
		ln -vs "client-${PV}" "${P}" || die
		mkdir -vp "${S}/src/github.com/keybase" || die
		ln -vs "${S}" "${S}/src/github.com/keybase/client" || die
	fi
}

src_compile() {
	pushd go/keybase || die
	ego build -tags production -o "${T}/${PN}" github.com/keybase/client/go/keybase
	use browser && (
		ego build -tags production -o "${T}/kbnm" github.com/keybase/client/go/kbnm
	)
	use kbfs && (
		ego build -tags production -o "${T}/kbfsfuse" github.com/keybase/client/go/kbfs/kbfsfuse
		ego build -tags production -o "${T}/git-remote-keybase" github.com/keybase/client/go/kbfs/kbfsgit/git-remote-keybase
		ego build -tags production -o "${T}/keybase-redirector" github.com/keybase/client/go/kbfs/redirector
	)
	use gui && (
		local arch
		use x86 && arch="ia32"
		use amd64 && arch="x64"
		cd "${S}"/shared/desktop
		# sed -i -e '/let aps /{s@platform, arch@arch, platform@}' "package.desktop.tsx" # typo? TODO: report
		type cross-env-shell &>/dev/null || npm install cross-env --legacy-peer-deps || die
		npm run package -- --platform linux --arch "${arch}" --appVersion "${PV}" || die
		# npm run build-prod -- --platform linux --arch "${arch}" --appVersion "${PV}" || die
	)
	popd || die
}

src_test() {
	pushd go/keybase || die
	ego test
	popd || die
}

src_install() {
	dobin "${T}/keybase"
	dobin "${S}/packaging/linux/run_keybase"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase.service"
	insinto "/opt/keybase"
	doins "${S}/packaging/linux/crypto_squirrel.txt"
	dodir "/opt/keybase"

	use gui && (
		local arch
		use x86 && arch="ia32"
		use amd64 && arch="x64"

		cd "${S}"/shared/desktop/release/linux-${arch}/Keybase-linux-${arch}
		# unbundle
		use system-libglvnd || (
			rm -f libGLESv2.so libEGL.so
			dosym ../../usr/$(get_libdir)/libGLESv2.so /opt/keybase/libGLESv2.so
			dosym ../../usr/$(get_libdir)/libEGL.so /opt/keybase/libEGL.so
		)
		use system-ffmpeg || (
			rm -f libffmpeg.so
			dosym ../../usr/$(get_libdir)/chromium/libffmpeg.so /opt/keybase/libffmpeg.so
		)
		use system-vulkan || (
			rm -f libvulkan.so.1
			dosym ../../usr/$(get_libdir)/libvulkan.so.1 /opt/keybase/libvulkan.so.1
		)
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
	if ! use kbfs; then
		elog "  Note that without USE=kbfs the kbfs service will not"
		elog "  be installed automatically. Either enable the flag"
		elog "  or export KEYBASE_NO_KBFS=1 in your shell to avoid"
		elog "  failures when executing run_keybase."
	fi
	elog "Run the service:       keybase service"
	elog "Run the client:        keybase login"
	ewarn "Note that the user keybasehelper is obsolete and can be removed"
}

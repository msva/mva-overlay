# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"

LICENSE="BSD"
SLOT="0"

# if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keybase/client.git"
# else
# 	SRC_URI="https://github.com/keybase/client/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# 	KEYWORDS="~amd64 ~x86"
# fi

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

S="${WORKDIR}/${P}/go"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
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
		cd ../shared/desktop
		sed -i -e '/let aps /{s@platform, arch@arch, platform@}' "package.desktop.tsx" # typo? TODO: report
		type cross-env-shell &>/dev/null || npm install cross-env --legacy-peer-deps || die
		npm run package -- --platform linux --arch "${arch}" --appVersion "${PV}" || die
		# npm run build-prod -- --platform linux --arch "${arch}" --appVersion "${PV}" || die
	)
}

src_install() {
	dobin "${T}/keybase"
	dobin "${S}/../packaging/linux/run_keybase"
	systemd_douserunit "${S}/../packaging/linux/systemd/keybase.service"
	insinto "/opt/keybase"
	doins "${S}/../packaging/linux/crypto_squirrel.txt"

	use gui && (
		local arch
		use x86 && arch="ia32"
		use amd64 && arch="x64"

		cd "${S}"/../shared/desktop/release/linux-${arch}/Keybase-linux-${arch}
		# unbundle
		use system-libglvnd || (
			rm -f libGLESv2.so libEGL.so
			ln -s /usr/$(get_libdir)/libGLESv2.so /opt/keybase/libGLESv2.so
			ln -s /usr/$(get_libdir)/libEGL.so /opt/keybase/libEGL.so
		)
		use system-ffmpeg || (
			rm -f libffmpeg.so
			ln -s /usr/$(get_libdir)/chromium/libffmpeg.so /opt/keybase/libffmpeg.so
		)
		use system-vulkan || (
			rm -f libvulkan.so.1
			ln -s /usr/$(get_libdir)/libvulkan.so.1 /opt/keybase/libvulkan.so.1
		)
		insinto "/opt/keybase"
		exeinto "/opt/keybase"
		doins -r *
		doexe chrome-sandbox Keybase

		systemd_douserunit "${S}/../packaging/linux/systemd/keybase.gui.service"
	)

	use browser && {
		dobin "${T}/kbnm"
		KBNM_INSTALL_ROOT=1 KBNM_INSTALL_OVERLAY="${D}" "${D}/usr/bin/kbnm" install
	}

	use kbfs && {
		dobin "${T}/kbfsfuse" "${T}/git-remote-keybase" "${T}/keybase-redirector"
		systemd_douserunit "${S}/../packaging/linux/systemd/kbfs.service"
		systemd_douserunit "${S}/../packaging/linux/systemd/keybase-redirector.service"
	}
}

pkg_postinst() {
	elog "Start/Restart keybase: run_keybase"
	elog "Run the service:       keybase service"
	elog "Run the client:        keybase login"
	ewarn "Note that the user keybasehelper is obsolete and can be removed"
}

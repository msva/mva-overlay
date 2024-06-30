# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="6G"
inherit check-reqs

DESCRIPTION="Open Handset Alliance's Android NDK (Native Dev Kit)"
HOMEPAGE="https://developer.android.com/ndk/"
SRC_URI="https://dl.google.com/android/repository/${PN}-r${PV}-linux.zip"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip installsources test"

RDEPEND="
	dev-build/make
	sys-libs/ncurses-compat:5[tinfo]
	virtual/libcrypt
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}-r${PV}"

ANDROID_NDK_DIR="opt/${PN}"

QA_PREBUILT="*"
PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	default
	rm -r toolchains/llvm/prebuilt/linux-x86_64/musl/lib/i686-unknown-linux-musl || die
	# linked against missing 32bit libc_musl.so (only 64bit shipped)
	# patchelf --set-rpath '$ORIGIN/:$ORIGIN/..' \
	# toolchains/llvm/prebuilt/linux-x86_64/musl/lib/i686-unknown-linux-musl/libc++.so.1
	# patchelf --set-rpath '$ORIGIN/:$ORIGIN/..' \
	# toolchains/llvm/prebuilt/linux-x86_64/musl/lib/x86_64-unknown-linux-musl/libc++.so.1
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	local dirs=(
		""
		build
		# platforms
		# ^ no more in 24 🤷
		prebuilt
		python-packages
		sources
		toolchains
	)
	dodir "/${ANDROID_NDK_DIR}"
	cp -pPR * "${ED}/${ANDROID_NDK_DIR}" || die

	dodir "/${ANDROID_NDK_DIR}/out"
	fowners -R root:android "/${ANDROID_NDK_DIR}"
	fperms 0775 "${dirs[@]/#//${ANDROID_NDK_DIR}/}"
	fperms 3775 "/${ANDROID_NDK_DIR}/out"

	ANDROID_PREFIX="${EPREFIX}/${ANDROID_NDK_DIR}"
	ANDROID_PATH="${EPREFIX}/${ANDROID_NDK_DIR}"

	for i in toolchains/*/prebuilt/linux-*/bin
	do
		ANDROID_PATH="${ANDROID_PATH}:${ANDROID_PREFIX}/${i}"
	done

	echo "PATH=\"${ANDROID_PATH}\"" > "${T}/80${PN}" || die
	doenvd "${T}/80${PN}"

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${ANDROID_NDK_DIR}\"" > "${T}/80${PN}" || die
	insinto "/etc/revdep-rebuild"
	doins "${T}/80${PN}"
}

pkg_postinst() {
	einfo "Probably, you will need to install dev-util/android-sdk-update-manager"
	einfo "And install SDK and tools through it"
}

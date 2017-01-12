# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

GH_URI='github/telegramdesktop/tdesktop'
if [[ "${PV}" != *9999* ]] ; then
	GH_REF="v${PV}"
	if [ -n "${TELEGRAM_DEBUG}" ]  ; then
		GH_FETCH_TYPE=live
		EGIT_CLONE_TYPE=shallow
	fi
fi

# xdg: src_prepare, pkg_preinst, pkg_post{inst,rm}
# git-hosting: src_unpack
inherit xdg git-hosting eutils flag-o-matic qmake-utils systemd versionator

TG_PRETTY_NAME="Telegram Desktop"
DESCRIPTION='Official desktop client for the Telegram messenger'
HOMEPAGE="https://desktop.telegram.org/ ${HOMEPAGE}"
LICENSE='GPL-3' # with OpenSSL exception

SLOT='0'

[[ "${PV}" == *9999* ]] || KEYWORDS="~amd64"
IUSE='autostart_generic autostart_plasma_systemd +pch proxy'

CDEPEND_A=(
	# Telegram requires shiny new versions since v0.10.1 and commit
	# https://github.com/telegramdesktop/tdesktop/commit/27cf45e1a97ff77cc56a9152b09423b50037cc50
	# list of required USE flags is taken from `.travis/build.sh`
	'>=media-video/ffmpeg-3.1:0=[mp3,opus,vorbis,wavpack]'	# 'libav*', 'libsw*'
	'>=media-libs/openal-1.17.2'	# 'openal', '<AL/*.h>'
	'dev-libs/openssl:0'
	'sys-libs/zlib[minizip]'		# replaces the bundled copy in 'Telegram/ThirdParty/minizip/'

	## X libs are taken from 'Telegram/Telegram.pro'
	'x11-libs/libXext'
	'x11-libs/libXi'
	'x11-libs/libxkbcommon'
	'x11-libs/libX11'

	# Indirect dep. Older versions cause issues through
	# 'qt-telegram-static' -> 'qtimageformats' -> 'libwebp' chain.
	# https://github.com/rindeal/gentoo-overlay/issues/123
	'>=media-libs/libwebp-0.4.2'
)
DEPEND_A=( "${CDEPEND_A[@]}"
	'=dev-qt/qt-telegram-static-5.6.0*'	# 5.6.0 is required since 0.9.49

	## CXXFLAGS pkg-config from 'Telegram/Telegram.pro'
	'dev-libs/libappindicator:2'
	'dev-libs/glib:2'
	'x11-libs/gtk+:2'

	'>=sys-apps/gawk-4.1'	# required for inplace support for .pro files formatter
	'virtual/pkgconfig'
)
RDEPEND_A=( "${CDEPEND_A[@]}"
	# block some alternative names and binary packages
	'!net-im/telegram'{,-bin}
	'!net-im/telegram-desktop-bin'
)

REQUIRED_USE_A=(
	'?? ( autostart_generic autostart_plasma_systemd )'
)

inherit arrays

RESTRICT+=' test'

L10N_LOCALES=( de es it ko nl pt_BR )
inherit l10n-r1

CHECKREQS_DISK_BUILD='1G'
inherit check-reqs

TG_DIR="${S}/Telegram"
TG_PRO="${TG_DIR}/Telegram.pro"
TG_INST_BIN="/usr/bin/${PN}"
TG_SHARED_DIR="/usr/share/${PN}"
TG_AUTOSTART_ARGS=( -startintray )
TG_SYSTEMD_SERVICE_NAME="${PN}"

# override qt5 path for use with eqmake5
qt5_get_bindir() { echo "${QT5_PREFIX}/bin" ; }

pkg_setup() {
	if use autostart_generic || use autostart_plasma_systemd ; then
		[[ -z "${TELEGRAM_AUTOSTART_USERS}" ]] && \
			die "You have enabled autostart_* USE flag, but haven't set TELEGRAM_AUTOSTART_USERS variable"
		for u in ${TELEGRAM_AUTOSTART_USERS} ; do
			id -u "${u}" >/dev/null || die "Invalid username '${u}' in TELEGRAM_AUTOSTART_USERS"
		done
	fi
}

src_prepare-locales() {
	local l locales dir='Resources/langs' pre='lang_' post='.strings'

	l10n_find_changes_in_dir "${dir}" "${pre}" "${post}"

	l10n_get_locales locales app off
	for l in ${locales} ; do
		rm -v -f "${dir}/${pre}${l}${post}" || die
		sed -r -e "s|^(.*${pre}${l}${post}.*)|<!-- locales \1 -->|" \
			-i -- 'Resources/telegram.qrc' || die
		sed -r -e "s|^(.*${dir}/${pre}${l}${post}.*)|# locales # \1|" \
			-i -- "${TG_PRO}" || die
	done
}

src_prepare-delete_and_modify() {
	local args

	## patch "${TG_PRO}"
	args=(
		# delete any references to local includes/libs
		-e 's|^(.*[^ ]*/usr/local/[^ \\]* *\\?)|# local includes/libs # \1|'
		# delete any hardcoded libs
		-e 's|^(.*LIBS *\+= *-l.*)|# hardcoded libs # \1|'
		# delete refs to bundled Google Breakpad
		-e 's|^(.*/breakpad.*)|# Google Breakpad # \1|'
		# delete refs to bundled minizip, Gentoo uses it's own patched version
		-e 's|^(.*/minizip.*)|# minizip # \1|'
		# delete CUSTOM_API_ID defines, use default ID
		-e 's|^(.*CUSTOM_API_ID.*)|# CUSTOM_API_ID # \1|'
		# remove hardcoded flags, but do not remove `$$PKG_CONFIG ...` appends
		-e 's|^(.*QMAKE_[A-Z]*FLAGS(_[A-Z]*)* *.= *-.*)|# hardcoded flags # \1|'
		# use release versions
		-e 's:(.*)Debug(Style|Lang)(.*):\1Release\2\3 # Debug -> Release Style/Lang:g'
		-e 's|(.*)/Debug(.*)|\1/Release\2 # Debug -> Release|g'
		# dee is not used
		-e 's|^(.*dee-1.0.*)|# dee not used # \1|'
	)
	sed -r "${args[@]}" \
		-i -- "${TG_PRO}" || die

	## lzma is not used when TDESKTOP_DISABLE_AUTOUPDATE is defined
	sed -r -e 's|^(.*<lzma\.h>.*)|// lzma not used // \1|' -i -- SourceFiles/autoupdater.cpp || die
	sed -r -e 's|^(.*liblzma.*)|# lzma not used # \1|' -i -- "${TG_PRO}" || die

	## opus is used from inside of ffmpeg and not as a dedicated library
	sed -r -e 's|^(.*opus.*)|# opus lib is not used # \1|' -i -- "${TG_PRO}" || die

	if ! use pch ; then
		# https://ccache.samba.org/manual.html#_precompiled_headers
		sed -r -e 's|^(.*PRECOMPILED_HEADER.*)|# USE=-pch # \1|' -i -- "${TG_PRO}" || die
	fi
}

src_prepare-appends() {
	# make sure there is at least one empty line at the end before adding anything
	echo >> "${TG_PRO}"

	printf '%s\n\n' '# --- EBUILD APPENDS BELOW ---' >> "${TG_PRO}" || die

	## add corrected dependencies back
	local deps=(
		minizip # upstream uses bundled copy
	)
	local libs=( "${deps[@]}"
		xkbcommon # upstream links xkbcommon statically
	)
	local includes=( "${deps[@]}" )

	local l i
	for l in "${libs[@]}" ; do
		echo "PKGCONFIG += ${l}" >>"${TG_PRO}" || die
	done
	for i in "${includes[@]}" ; do
		printf 'QMAKE_CXXFLAGS += `%s %s`\n' '$$PKG_CONFIG --cflags-only-I' "${i}" >>"${TG_PRO}" || die
	done

	if ! use pch ; then
		# https://ccache.samba.org/manual.html#_precompiled_headers
		echo "QMAKE_CXXFLAGS += -include \"${TG_DIR}/SourceFiles/stdafx.h\"" >>"${TG_PRO}" || die
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/0.10.1-revert_Round_radius_increased_for_message_bubbles.patch

	xdg_src_prepare

	cd "${TG_DIR}" || die

	rm -rf *.*proj*		|| die # delete Xcode/MSVS files
	rm -rf ThirdParty	|| die # prevent accidentically using something from there

	## determine which qt-telegram-static version should be used
	if [ -z "${QT_TELEGRAM_STATIC_SLOT}" ] ; then
		local qtstatic='dev-qt/qt-telegram-static'
		local qtstatic_PVR="$(best_version "${qtstatic}" | sed "s|.*${qtstatic}-||")"
		local qtstatic_PV="${qtstatic_PVR%%-*}" # strip revision
		declare -g QT_VER="${qtstatic_PV%%_p*}" QT_PATCH_NUM="${qtstatic_PV##*_p}"
		declare -g QT_TELEGRAM_STATIC_SLOT="${QT_VER}-${QT_PATCH_NUM}"
	else
		einfo "Using QT_TELEGRAM_STATIC_SLOT from environment - '${QT_TELEGRAM_STATIC_SLOT}'"
		declare -g QT_VER="${QT_TELEGRAM_STATIC_SLOT%%-*}" QT_PATCH_NUM="${QT_TELEGRAM_STATIC_SLOT##*-}"
	fi

	echo
	einfo "${P} is going to be linked with 'Qt ${QT_VER} (p${QT_PATCH_NUM})'"
	echo

	# WARNING: QT5_PREFIX path depends on what qt-telegram-static ebuild uses
	declare -g QT5_PREFIX="${EPREFIX}/opt/qt-telegram-static/${QT_VER}/${QT_PATCH_NUM}"
	[ -d "${QT5_PREFIX}" ] || die "QT5_PREFIX dir doesn't exist: '${QT5_PREFIX}'"

	readonly QT_TELEGRAM_STATIC_SLOT QT_VER  QT_PATCH_NUM QT5_PREFIX

	# This formatter converts multiline var defines to multiple lines.
	# Such .pro files are then easier to debug and modify in src_prepare-delete_and_modify().
	einfo "Formatting .pro files"
	gawk -f "${FILESDIR}/format_pro.awk" -i inplace -- *.pro || die

	src_prepare-locales
	src_prepare-delete_and_modify
	src_prepare-appends
}

src_configure() {
	## add flags previously stripped from "${TG_PRO}"
	append-cxxflags '-fno-strict-aliasing'
	# `append-ldflags '-rdynamic'` was stripped because it's used probably only for GoogleBreakpad
	# which is not supported anyway

	# care a little less about the unholy mess
	append-cxxflags '-Wno-unused-'{function,parameter,variable,but-set-variable}
	append-cxxflags '-Wno-switch'

	# prefer patched qt
	export PATH="$(qt5_get_bindir):${PATH}"

	# available since https://github.com/telegramdesktop/tdesktop/commit/562c5621f507d3e53e1634e798af56851db3d28e
	export QT_TDESKTOP_VERSION="${QT_VER}"
	export QT_TDESKTOP_PATH="${QT5_PREFIX}"

	(	# disable updater
		echo 'DEFINES += TDESKTOP_DISABLE_AUTOUPDATE'

		# disable google-breakpad support
		echo 'DEFINES += TDESKTOP_DISABLE_CRASH_REPORTS'

		# disable .desktop file generation
		echo 'DEFINES += TDESKTOP_DISABLE_DESKTOP_FILE_GENERATION'

		# https://github.com/telegramdesktop/tdesktop/commit/0b2bcbc3e93a7fe62889abc66cc5726313170be7
		$(usex proxy 'DEFINES += TDESKTOP_DISABLE_NETWORK_PROXY' '')

		# disable registering `tg://` scheme from within the app
		echo 'DEFINES += TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME'

		# remove Unity support
		echo 'DEFINES += TDESKTOP_DISABLE_UNITY_INTEGRATION'
	) >>"${TG_PRO}" || die
}

my_eqmake5() {
	local args=(
		CONFIG+='release'
	)
	eqmake5 "${args[@]}" "$@"
}

src_compile() {
	local d module

	## NOTE: directory naming follows upstream and is hardcoded in .pro files

	for module in style numbers ; do	# order of modules matters
		d="${S}/Linux/obj/codegen_${module}/Release"
		mkdir -v -p "${d}" && cd "${d}" || die

		einfo "Building: ${PWD/${S}\/}"
		my_eqmake5 "${TG_DIR}/build/qmake/codegen_${module}/codegen_${module}.pro"
		emake
	done

	for module in Lang ; do		# order of modules matters
		d="${S}/Linux/ReleaseIntermediate${module}"
		mkdir -v -p "${d}" && cd "${d}" || die

		einfo "Building: ${PWD/${S}\/}"
		my_eqmake5 "${TG_DIR}/Meta${module}.pro"
		emake
	done

	d="${S}/Linux/ReleaseIntermediate"
	mkdir -v -p "${d}" && cd "${d}" || die

	einfo "Preparing the main build ..."
	einfo "Note: ignore the warnings/errors below"
	# this qmake will fail to find "${TG_DIR}/GeneratedFiles/*", but it's required for ...
	my_eqmake5 "${TG_PRO}"
	# ... this make, which will generate those files
	local targets=( $( awk '/^PRE_TARGETDEPS *\+=/ { $1=$2=""; print }' "${TG_PRO}" ) )
	(( ${#targets[@]} )) || die
	emake ${targets[@]}

	# now we have everything we need, so let's begin!
	einfo "Building Telegram ..."
	my_eqmake5 "${TG_PRO}"
	emake
}

HEADER_FOR_GEN_FILES=(
	"# DO NOT MODIFY: This file is a part of the ${CATEGORY}/${PN} package"
	"# generated on $(date --utc --iso-8601=minutes)"
)

my_install_systemd_service() {
	local tmpfile="$(mktemp)"
	cat <<-_EOF_ > "${tmpfile}" || die
		$(printf "%s\n" "${HEADER_FOR_GEN_FILES[@]}")
		[Unit]
		Description=${TG_PRETTY_NAME} messaging app
		# standard targets are not available in user mode, so no deps can be specified

		[Service]
		ExecStartPre=/bin/sh -c "[ -n \"${DISPLAY}\" ]"
		# list of all cmdline options is in 'Telegram/SourceFiles/settings.cpp'
		ExecStart="${EPREFIX}${TG_INST_BIN}" "${TG_AUTOSTART_ARGS[@]}"
		Restart=on-failure
		RestartSec=1min

		# no "Install" section as this service can only be started manually or via a script
		# systemd
	_EOF_
	systemd_newuserunit "${tmpfile}" ${TG_SYSTEMD_SERVICE_NAME}.service
}

my_install_autostart_sh() {
	local tmpfile="$(mktemp)"
	cat <<-_EOF_ > "${tmpfile}" || die
		#!/bin/sh
		$(printf "%s\n" "${HEADER_FOR_GEN_FILES[@]}")
		"${EPREFIX}/usr/bin/systemctl" --user start ${TG_SYSTEMD_SERVICE_NAME}.service
	_EOF_
	insinto "${TG_SHARED_DIR}"/autostart-scripts
	newins "${tmpfile}" 10-${PN}.sh
}

my_install_shutdown_sh() {
	local tmpfile="$(mktemp)"
	cat <<-_EOF_ > "${tmpfile}" || die
		#!/bin/sh
		$(printf "%s\n" "${HEADER_FOR_GEN_FILES[@]}")
		"${EPREFIX}/usr/bin/systemctl" --user stop ${TG_SYSTEMD_SERVICE_NAME}.service
	_EOF_
	insinto "${TG_SHARED_DIR}"/shutdown
	newins "${tmpfile}" 10-${PN}.sh
}

my_install_autostart_desktop() {
	local tmpfile="$(mktemp)"
	cat <<-_EOF_ > "${tmpfile}" || die
		$(printf "%s\n" "${HEADER_FOR_GEN_FILES[@]}")
		[Desktop Entry]
		Version=1.0

		Name=${TG_PRETTY_NAME}
		Type=Application

		Exec="${EPREFIX}${TG_INST_BIN}" "${TG_AUTOSTART_ARGS[@]}"
		Terminal=false
	_EOF_
	insinto "${TG_SHARED_DIR}"/autostart
	newins "${tmpfile}" ${PN}.desktop
}

my_install_autostart_howto() {
	local tmpfile="$(mktemp)"
	cat <<-_EOF_ > "${tmpfile}" || die
		You can set it up either automatically using Portage or manually.

		Automatically
		--------------
		Enable one of autostart_* USE flags for ${CATEGORY}/${PN} package and
		set TELEGRAM_AUTOSTART_USERS variable in make.conf to a space-separated list
		of user names for which you'd like to set it up.

		Manually
		---------

		If you have KDE Plasma + systemd:

		\`\`\`
		cp -v "${EPREFIX}${TG_SHARED_DIR}"/autostart-scripts/* ~/.config/autostart-scripts/
		cp -v "${EPREFIX}${TG_SHARED_DIR}"/shutdown/* ~/.config/plasma-workspace/shutdown/
		\`\`\`

		otherwise:

		\`\`\`
		cp -v "${EPREFIX}${TG_SHARED_DIR}"/autostart/* ~/.config/autostart/
		\`\`\`
	_EOF_
	insinto "${TG_SHARED_DIR}"
	newins "${tmpfile}" autostart-howto.txt
}

src_install() {
	newbin "${S}/Linux/Release/Telegram" "${TG_INST_BIN##*/}"

	## docs
	einstalldocs

	## icons
	local s
	for s in 16 32 48 64 128 256 512 ; do
		newicon -s ${s} "${TG_DIR}/Resources/art/icon${s}.png" "${PN}.png"
	done

	## .desktop entry -- upstream version at 'lib/xdg/telegramdesktop.desktop'
	local make_desktop_entry_args
	make_desktop_entry_args=(
		"${EPREFIX}${TG_INST_BIN} -- %u"	# exec
		"${TG_PRETTY_NAME}"	# name
		"${TG_INST_BIN##*/}"	# icon
		'Network;InstantMessaging;Chat;'	# categories
	)
	make_desktop_entry_extras=(
		'MimeType=x-scheme-handler/tg;'
		'StartupWMClass=Telegram'	# this should follow upstream
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"

	## systemd
	my_install_systemd_service

	## autostart -- plasma + systemd
	my_install_autostart_sh
	my_install_shutdown_sh
	if use autostart_plasma_systemd ; then
		local u
		for u in ${TELEGRAM_AUTOSTART_USERS} ; do
			local homedir="$(eval "echo ~${u}")"

			install -v --owner="${u}" --mode=700 \
				-D --target-directory="${D}/${homedir}"/.config/autostart-scripts/ \
				-- "${ED}"/${TG_SHARED_DIR}/autostart-scripts/* || die
			install -v --owner="${u}" --mode=700 \
				-D --target-directory="${D}/${homedir}"/.config/plasma-workspace/shutdown/ \
				-- "${ED}"/${TG_SHARED_DIR}/shutdown/* || die
		done
	fi

	## autostart -- other DEs
	my_install_autostart_desktop
	if use autostart_generic ; then
		local u
		for u in ${TELEGRAM_AUTOSTART_USERS} ; do
			local homedir="$(eval "echo ~${u}")"

			install -v --owner="${u}" --mode=600 \
				-D --target-directory="${D}/${homedir}"/.config/autostart/ \
				-- "${ED}"/${TG_SHARED_DIR}/autostart/* || die
		done
	fi

	## autostart -- tutorial
	my_install_autostart_howto
}

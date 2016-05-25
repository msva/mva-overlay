# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 toolchain-funcs flag-o-matic qmake-utils

EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop"
EGIT_BRANCH="master"

IUSE="debug"
DESCRIPTION="Telegram Desktop messaging app"
HOMEPAGE="https://telegram.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
"

src_prepare() {
	local mode=release;
	local sedargs=()

	use debug && mode=debug;

	rm -r "${S}/Telegram/ThirdParty"

	# Safety newline, just for sure
	sed -i '$a\\n' "${S}/Telegram/Telegram.pro"

	local deps=(
		'appindicator3-0.1'
		'minizip'
	)
	local libs=(
		"${deps[@]}"
		'lib'{avcodec,avformat,avutil,swresample,swscale,va,lzma}
		'opus'
		'openal'
		'openssl'
		'zlib'
	)
	local defs=(
		"TDESKTOP_DISABLE_AUTOUPDATE"
		"TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
		"TDESKTOP_DISABLE_CRASH_REPORTS"
	)
	local includes=( "${deps[@]}" ) # dee-1.0 # TODO

	sedargs+=(
		# delete any references to local includes/libs
		-e 's|[^ ]*/usr/local/[^ \\]* *(\\?)| \1|'
		# delete any hardcoded includes
		-e 's|(.*INCLUDEPATH *\+= *"/usr.*)|#__hardcoded includes#\1|'
		# delete any hardcoded libs
		-e 's|(.*LIBS *\+= *-l.*)|#__hardcoded libs#\1|'
		# delete refs to bundled Google Breakpad
		-e 's|(.*breakpad/src.*)|#__hardcoded Google Breakpad#\1|'
		# delete refs to bundled minizip, Gentoo uses it's own patched version
		-e 's|(.*minizip.*)|#__hardcoded minizip#\1|'
		# delete CUSTOM_API_ID defines, use default ID
		-e 's|(.*CUSTOM_API_ID.*)|#CUSTOM_API_ID#\1|'
		# remove hardcoded flags
		-e 's|(.*QMAKE_[A-Z]*FLAGS.*)|#__hardcoded flags#\1|'
		# use release versions
		-e "s:Debug(Style|Lang):${mode^}\1:g"
		-e "s|/Debug|/${mode^}|g"
		# fix Qt version
		-e "s|5.6.0|${qt_ver}|g"
		-e "/#__hardcoded .*#/d"
		-e "/stdafx.cpp/d"
	)

	for i in "${includes[@]}"; do
		sedargs+=( -e "\$aQMAKE_CXXFLAGS += $(pkg-config --cflags-only-I ${i})" )
	done

	for l in "${libs[@]}"; do
		sedargs+=( -e "\$aLIBS += $(pkg-config --libs ${l})" )
	done

	for d in "${defs[@]}"; do
		sedargs+=( -e "\$aDEFINES += ${d}" )
	done

	sed -i -r "${sedargs[@]}" "${S}/Telegram/Telegram.pro" || die "Can't patch Telegram.pro"

	## nuke libunity references
	sedargs=(
		# ifs cannot be deleted, so replace them with 0
		-e 's|if *\( *_psUnityLauncherEntry *\)|if(0)|'
		# this is probably not needed, but anyway
		-e 's|noTryUnity *= *false,|noTryUnity = true,|'
		# delete includes
		-e 's|(.*unity\.h.*)|// \1|'
		# delete various refs
		-e 's|(.*f_unity*)|// \1|'
		-e 's|(.*ps_unity_*)|// \1|'
		-e 's|(.*UnityLauncher*)|// \1|'
	)
	sed -i -r "${sedargs[@]}" "${S}/Telegram/SourceFiles/pspecific_linux.cpp" || die "Can't nuke-unity patch"

	epatch "${FILESDIR}"/no-calls-to-private-methods.patch

#	sed -i -e '/gf/d' "${S}/Telegram/SourceFiles/ui/text/text.cpp"
}

src_configure() {
	local qt_ver=$(qmake -query QT_VERSION)
	append-cxxflags "-I/usr/include/qt5/QtGui/${qt_ver}/QtGui"
	append-cxxflags "-I/usr/include/qt5/QtCore/${qt_ver}/QtCore"
	append-cxxflags '-fno-strict-aliasing'
	append-cxxflags '-Wno-unused-'{function,parameter,variable,result,but-set-variable}
	append-cxxflags '-Wno-switch'
}

src_compile() {
	local d mode='release' module

	use debug && mode=debug

	for module in style numbers ; do	# order of modules matters
		d="${S}/Linux/obj/codegen_${module}/${mode^}"
		mkdir -v -p "${d}" && cd "${d}" || die

		elog "Building: ${PWD/${S}\/}"
		eqmake5 CONFIG+="${mode}" \
			"${S}/Telegram/build/qmake/codegen_${module}/codegen_${module}.pro"
		emake
	done

	for module in Lang ; do		# order of modules matters
		d="${S}/Linux/${mode^}Intermediate${module}"
		mkdir -v -p "${d}" && cd "${d}" || die

		elog "Building: ${PWD/${S}\/}"
		eqmake5 CONFIG+="${mode}" "${S}/Telegram/Meta${module}.pro"
		emake
	done

	d="${S}/Linux/${mode^}Intermediate"
	mkdir -v -p "${d}" && cd "${d}" || die

	elog "Preparing the main build ..."
	# this qmake will fail to find "${tg_dir}/GeneratedFiles/*", but it's required for ...
	eqmake5 CONFIG+="${mode}" "${S}/Telegram/Telegram.pro"
	# ... this make, which will generate those files
	local targets=( $( awk '/^PRE_TARGETDEPS *\+=/ { $1=$2=""; print }' "${S}/Telegram/Telegram.pro" ) )
	[ ${#targets[@]} -eq 0 ] && die
	emake ${targets[@]}

	# now we have everything we need, so let's begin!
	elog "Building Telegram ..."
	eqmake5 CONFIG+="${mode}" "${S}/Telegram/Telegram.pro"
	emake
}

#src_install() {
#	dobin bin/telegram
#
#	insinto /etc/telegram-cli/
#	newins tg-server.pub server.pub
#}

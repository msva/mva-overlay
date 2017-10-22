# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: patches.eclass
# @MAINTAINER:
# mva
# @AUTHOR:
# mva
# @BLURB:
# @DESCRIPTION:
# Eclass that checks for patches directories existance and auto-add them into PATCHES=()

EXPORT_FUNCTIONS src_prepare

PATCHDIR="${FILESDIR}/patches/${PV}"
[[ -z ${PATCHES[@]} ]] && PATCHES=()

patches_src_prepare() {
	if [[ -d "${PATCHDIR}" ]]; then
		PATCHES+=("${PATCHDIR}")
		if [[ -d "${PATCHDIR}/conditional" ]]; then
			pushd "${PATCHDIR}/conditional" &>/dev/null
			for d in *; do
				if [[ -d ${d} ]]; then
					if [[ "${d##no-}" == ${d} ]]; then
						use "${d}" && PATCHES+=("${PATCHDIR}/conditional/${d}")
					else
						use "${d##no-}" || PATCHES+=("${PATCHDIR}/conditional/${d}")
					fi
				fi
			done
			popd &>/dev/null
		fi
	fi
	if declare -f cmake-utils_src_prepare &>/dev/null; then
		# cmake-utils_src_prepare support (to decrease kludges in the ebuilds)
		cmake-utils_src_prepare
	else
		default_src_prepare
	fi
}

# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: patches.eclass
# @MAINTAINER:
# mva
# @AUTHOR:
# mva
# @BLURB: autopatching magic (pretty useful for me, but criticized for obscurity and looks like not suitable for gentoo repo)
# @DESCRIPTION:
# Eclass that checks for patches directories existance and auto-add them into PATCHES=()

EXPORT_FUNCTIONS src_prepare


patches_src_prepare() {
	[[ -z ${PATCHES[@]} ]] && PATCHES=()
	PATCHDIR_BASE="${FILESDIR}/patches"
	PATCHDIRS=("${CUSTOM_PATCHDIR:-non-existant-dir}" "${SLOT//\/*}" "${PV}" "${PV}-${PR}")
	for PATCHDIR in ${PATCHDIRS[@]/#/${PATCHDIR_BASE}/}; do
		if [[ -d "${PATCHDIR}" ]]; then
			_patchdir_not_empty() {
				local has_files
				local LC_ALL=POSIX
				local prev_shopt=$(shopt -p nullglob)
				shopt -s nullglob
				local f
				local lvl=${2}
				for f in "${1:-${PATCHDIR}}"/*; do
					if [[ "${f}" == *.diff || "${f}" == *.patch ]] && [[ -f "${f}" || -L "${f}" ]]; then
						has_files=1
					elif [[ -d "${f}" ]] && [[ "${lvl:-0}" -eq 0 ]]; then
						# limit recursion to first level only,
						# since eapply cannot into recursion,
						# while 2-lvl "conditional" patching implemented below
						let lvl+=1
						_patchdir_not_empty "${f}" "${lvl}" && has_files=1
					fi
				done
				${prev_shopt}
				[[ -n "${has_files}" ]]; return $?
			}

			_patchdir_not_empty && PATCHES+=("${PATCHDIR}")

			if [[ -d "${PATCHDIR}/conditional" ]]; then
				pushd "${PATCHDIR}/conditional" &>/dev/null
				for d in *; do
					if [[ -d ${d} ]]; then
						if [[ "${d##no-}" == ${d} ]]; then
							(use "${d}" && _patchdir_not_empty "${d}") && PATCHES+=("${PATCHDIR}/conditional/${d}")
						else
							(use "${d##no-}" && _patchdir_not_empty "${d}") || PATCHES+=("${PATCHDIR}/conditional/${d}")
						fi
					fi
				done
				popd &>/dev/null
			fi
		fi
	done
	if declare -f cmake-utils_src_prepare &>/dev/null; then
		cmake-utils_src_prepare
	elif declare -f cmake_src_prepare &>/dev/null; then
		cmake_src_prepare
	else
		default_src_prepare
	fi
}

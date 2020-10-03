#!zsh
NGE=${1}

SPL='
	s|\.| |g;
	s|([[:digit:]])([^[:digit:] ])|\1 \2|g;
	s|([^[:digit:] ])([[:digit:]])|\1 \2|g;
	s|[_-]*r ([[:digit:]])|0.\1|g;
	s|[_-]*alpha|-40|g;
	s|[_-]*beta|-20|g;
	s|[_-]*rc|-10|g;
'

_pcmp() {
  if [[ -z "${1//[[:digit:].-]/}" ]] && [[ -z "${2//[[:digit:].-]/}" ]]; then
    (( ${1:-0} == ${2:-0} )) && return 0
    (( ${1:-0} > ${2:-0} )) && return 1
    (( ${1:-0} < ${2:-0} )) && return 2
  else
    [[ "$1" == "$2" ]] && return 0
    [[ "$1" > "$2" ]] && return 1
    [[ "$1" < "$2" ]] && return 2
  fi
  echo "Universe is broken! Versions neither equal nor one of them is bigger"; exit 1
}

newer() {
  local pkg_pv pkg_pv_new i result
  pkg_pv=($(sed -re "$SPL" <<< "$1"))
  pkg_pv_new=($(sed -re "$SPL" <<< "$2"))
  i=1;

  while (( i <= ${#pkg_pv[@]} )) && (( i <= ${#pkg_pv_new[@]} )); do
    _pcmp "${pkg_pv[i]}" "${pkg_pv_new[i]}"
    [[ $? == 2 ]] && return 0
    let i++
  done
  _pcmp "${pkg_pv[i]}" "${pkg_pv_new[i]}"
  [[ $? == 2 ]] && return 0
}

awk \
	'/^# .*https:\/\/github.com/{print gensub(/.*(https:\/\/.*\/tags).*/,"\\1","g",$0)}' \
	${NGE} | while read taglink; do
		[[ ${taglink} =~ 'dreamcommerce' ]] && continue;
		grep -A4 ${taglink} ${NGE} | grep _PV | IFS== read -r pkg_pv_var pkg_pv;
		pkg_name=${pkg_pv_var//_PV}
		[[ "${pkg_name}" = '#'* ]] && continue;

#		[[ "${pkg_name}" != *AJP* && "${pkg_name}" != *RRD* ]] && continue || print "${pkg_name} matched" #temp kludge

#		spaces=$(for i in {1..$(( COLUMNS - (${#pkg_name}) - (COLUMNS/100*90) ))}; do echo -n '\\_'; done)
		pkg_pv=${pkg_pv//\"};
		pkg_pv_new=$(curl -Ls ${taglink} 2>/dev/null | grep -v 'latest-' | awk '/href=.*archive.*.tar.gz/{print gensub(/.*href=".*\/archive\/[^0-9.]*([0-9a-zA-Z.-]+).tar.gz".*/,"\\1","g",$0); exit}');

		[[ "${pkg_name}" == *PAGESPEED* && ( "${pkg_pv_new}" == *-RC* || "${pkg_pv_new}" == *-beta ) ]] && pkg_pv_new="${pkg_pv}"
		[[ -z "${pkg_pv_new}" ]] && pkg_pv_new="${pkg_pv}" # safety check

		if newer "${pkg_pv}" "${pkg_pv_new}"; then
			sed -e "/^${pkg_name}_PV/s|${pkg_pv}|${pkg_pv_new}|;/^${pkg_name}_SHA=/s|^|#|" -i "${NGE}" &&
			echo "[${pkg_name}] PV updated: from ${pkg_pv} to ${pkg_pv_new}"
		elif grep -q "^${pkg_name}_SHA=" "${NGE}"; then
			grep "^${pkg_name}_SHA=" "${NGE}" | IFS== read -r pkg_sha_var pkg_sha;
			pkg_sha=${pkg_sha//\"}
			pkg_sha_new=$(curl -Ls ${taglink/tags/commit\/HEAD} 2>/dev/null | awk '/sha-block.*commit/{print gensub(/.*"sha .*">([^<]*)<.*/,"\\1","g",$0); exit}');
			[[ "${pkg_sha_new}" != "${pkg_sha}" ]] && (
				sed -e "/^${pkg_name}_SHA=/s|${pkg_sha}|${pkg_sha_new}|" -i "${NGE}" &&
				echo "[${pkg_name}] SHA updated: from ${pkg_sha} to ${pkg_sha_new}"
			)
		fi
		unset pkg_pv pkg_pv_var pkg_pv_new pkg_sha pkg_sha_var pkg_sha_new
	done

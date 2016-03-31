#!zsh
NGE=${1}

awk \
	'/^# .*https:\/\/github.com/{print gensub(/.*(https:\/\/.*\/tags).*/,"\\1","g",$0)}' \
	${NGE} | while read taglink; do
		[[ ${taglink} =~ 'dreamcommerce' ]] && continue;
		grep -A4 ${taglink} ${NGE} | grep _PV | IFS== read -r pkg_name pkg_pv;
#		[[ ${pkg_name} = '#'* ]] && continue;
		spaces=$(for i in {1..$((${COLUMNS}-(${#pkg_name})-115))}; do echo -n '\\:'; done)
		old=${pkg_pv//\"};
		new=$(curl -s ${taglink} 2>/dev/null | awk '/href=.*archive.*.tar.gz/{print gensub(/.*href=".*\/archive\/[^0-9.]*([0-9a-z.-]+).tar.gz".*/,"\\1","g",$0); exit}');
		if [ ! "${old}" = "${new}" ]; then
			print "${pkg_name} ${spaces} OLD: ${old} NEW: ${new}"
		fi
		unset old new
	done


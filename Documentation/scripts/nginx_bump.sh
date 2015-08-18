#!zsh
NGE=${1}

awk \
	'/^# .*https:\/\/github.com/{print gensub(/.*(https:\/\/.*\/tags).*/,"\\1","",$0)}' \
	${NGE} | while read taglink; do
grep -A4 ${taglink} ${NGE} | grep _PV | IFS== read -r pkg_pv_var_name pkg_pv;
spaces=$(for i in {1..$((${COLUMNS}-(${#pkg_pv_var_name})-115))}; do echo -n '\\:'; done)
eval ${pkg_pv_var_name}_old=${pkg_pv};
eval ${pkg_pv_var_name}_new=$(curl -s ${taglink} 2>/dev/null | awk '/href=.*archive.*.tar.gz/{print gensub(/.*href=".*\/archive\/[^0-9.]*([0-9a-z.-]+).tar.gz".*/,"\\1","",$0); exit}');
eval print ${pkg_pv_var_name} "${spaces}" OLD: \$${pkg_pv_var_name}_old NEW: \$${pkg_pv_var_name}_new
done


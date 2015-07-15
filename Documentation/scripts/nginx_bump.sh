#cd www-servers/nginx
awk \
	'/^# .*https:\/\/github.com/{print gensub(/.*(https:\/\/.*\/tags).*/,"\\1","",$0)}' \
	nginx-1.9.3.ebuild | while read taglink; do
curl -s ${taglink} | awk \
	'/href=.*archive.*.tar.gz/{print "https://github.com" gensub(/.*href="(.*\/archive\/.*.tar.gz)".*/,"\\1","",$0); exit}';
done


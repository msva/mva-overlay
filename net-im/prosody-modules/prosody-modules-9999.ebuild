# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="https://modules.prosody.im/"
EHG_REPO_URI="https://hg.prosody.im/prosody-modules"

LICENSE="MIT"
SLOT="0"

IUSE="misc"

PROSODY_MODULES="
	addressing adhoc-account-management adhoc-blacklist adhoc-dataforms-demo
	adhoc-groups adhoc-oauth2-client admin-blocklist admin-message
	admin-notify admin-probe admin-web alias atom audit audit-auth
	audit-register auth-any auth-ccert auth-custom-http auth-cyrus
	auth-dovecot auth-external-insecure auth-ha1 auth-http auth-http-async
	auth-http-cookie auth-imap auth-internal-yubikey auth-joomla auth-ldap
	auth-ldap2 auth-oauthbearer auth-pam auth-phpbb3 auth-sql auth-token
	auth-wordpress auto156 auto-accept-subscriptions auto-activate-hosts
	auto-answer-disco-info auto-moved aws-profile benchmark-storage bidi
	bind2 block-outgoing block-registrations block-s2s-subscriptions
	block-strangers block-subscribes block-subscriptions blocking bob
	bookmarks bookmarks2 broadcast c2s-conn-throttle c2s-limit-sessions
	cache-c2s-caps captcha-registration carbons carbons-adhoc carbons-copies
	checkcerts client-certs client-proxy cloud-notify cloud-notify-encrypted
	cloud-notify-extensions cloud-notify-filters cloud-notify-priority-tag
	compact-resource compat-bind compat-dialback compat-muc-admin
	compat-vcard compliance-2021 component-client component-http
	component-roundrobin compression-unsafe conformance-restricted
	conversejs couchdb csi csi-battery-saver csi-compat csi-grace-period
	csi-muc-priorities csi-simple-compat data-access debug-omemo
	debug-traceback default-bookmarks default-vcard delegation deny-omemo
	devices disable-tls discodot discoitems dnsupdate dwd e2e-policy
	easy-invite email email-pass export-skeletons extdisco external-services
	fallback-vcard file-management filter-chatstates filter-words firewall
	flash-policy graceful-shutdown group-bookmarks groups-internal
	groups-migration groups-muc-bookmarks groups-shell host-blacklist
	host-guard host-status-check host-status-heartbeat http-admin-api
	http-altconnect http-auth-check http-authentication http-avatar
	http-dir-listing http-dir-listing2 http-favicon http-host-status-check
	http-hostaliases http-index http-libjs http-logging http-muc-kick
	http-muc-log http-oauth2 http-pep-avatar http-prebind http-rest
	http-roster-admin http-stats-stream http-upload http-upload-external
	http-user-count http-xep227 idlecompat ignore-host-chatstates
	incidents-handling inject-ecaps2 inotify-reload invite invites
	invites-adhoc invites-api invites-groups invites-page invites-register
	invites-register-api invites-register-web invites-tracking ipcheck
	isolate-host jid-prep json-streams jsxc lastlog lastlog2 latex lib-ldap
	limit-auth limits limits-exception list-active list-inactive listusers
	log-auth log-events log-events-by-cpu-usage log-events-by-memory
	log-http log-json log-mark log-messages-sql log-rate log-ringbuffer
	log-sasl-mech log-slow-events mam mam-adhoc mam-archive mam-muc mamsub
	manifesto map measure-active-users measure-client-features
	measure-client-identities measure-client-presence measure-cpu
	measure-lua measure-malloc measure-memory measure-message-e2ee
	measure-message-length measure-muc measure-process measure-registration
	measure-stanza-counts measure-storage message-logging migrate
	migrate-http-upload minimix motd-sequential muc-access-control
	muc-archive muc-auto-reserve-nicks muc-badge muc-ban-ip
	muc-batched-probe muc-block-pm muc-bot muc-cloud-notify
	muc-config-restrict muc-defaults muc-dicebot muc-eventsource muc-gc10
	muc-hats-adhoc muc-hats-api muc-hide-media muc-http-auth
	muc-http-defaults muc-inject-mentions muc-intercom muc-lang muc-limits
	muc-local-only muc-log muc-log-http muc-mam-hints muc-mam-markers
	muc-markers muc-media-metadata muc-mention-notifications muc-moderation
	muc-notifications muc-occupant-id muc-offline-delivery muc-ping muc-rai
	muc-require-tos muc-restrict-media muc-restrict-nick muc-restrict-rooms
	muc-rtbl muc-search muc-webchat-url munin net-dovecotauth net-proxy
	nodeinfo2 nooffline-noerror offline-email offline-hints ogp
	omemo-all-access onhold onions openid password-policy password-reset
	pastebin pep-atom-categories pep-vcard-avatar pep-vcard-png-avatar
	persisthosts ping-muc pinger poke-strangers portcheck post-msg
	presence-cache presence-dedup privacy-lists private-adhoc privilege
	proctitle profile prometheus proxy65-whitelist pubsub-alertmanager
	pubsub-eventsource pubsub-feeds pubsub-github pubsub-hub pubsub-mqtt
	pubsub-pivotaltracker pubsub-post pubsub-stats pubsub-subscription
	pubsub-summary pubsub-text-interface pubsub-twitter query-client-ver
	rawdebug readonly register-apps register-dnsbl
	register-dnsbl-firewall-mark register-dnsbl-warn register-json
	register-oob-url register-redirect register-web reload-components
	reload-modules reminders remote-roster require-otr rest roster-allinall
	roster-command s2s-auth-compat s2s-auth-dane s2s-auth-fingerprint
	s2s-auth-monkeysphere s2s-auth-posh s2s-auth-samecert s2s-blacklist
	s2s-idle-timeout s2s-keepalive s2s-keysize-policy s2s-log-certs
	s2s-never-encrypt-blacklist s2s-reload-newcomponent s2s-status
	s2s-whitelist s2soutinjection sasl2 sasl-oauthbearer saslauth-muc
	saslname seclabels secure-interfaces sentry server-status
	service-directories sift slack-webhooks smacks smacks-noerror
	smacks-offline sms-clickatell sms-free spam-reporting srvinjection
	sslv3-warn stanza-counter stanzadebug statistics statistics-auth
	statistics-cputotal statistics-mem statistics-statsman stats39 statsd
	storage-appendmap storage-ejabberdsql-readonly storage-gdbm storage-ldap
	storage-lmdb storage-memory storage-mongodb storage-muc-log
	storage-muconference-readonly storage-multi storage-xmlarchive
	streamstats strict-https support-contact support-room swedishchef
	tcpproxy telnet-tlsinfo test-data throttle-presence throttle-unsolicited
	tls-policy tlsfail tos traceback track-muc-joins turn-external
	turncredentials tweet-data twitter uptime-presence vcard-command
	vcard-muc vjud warn-legacy-tls watch-spam-reports watchuntrusted
	webpresence welcome-page xhtmlim
"

for x in ${PROSODY_MODULES}; do
	IUSE="${IUSE} ${x//[^+]/}prosody_modules_${x/+}"
done

DEPEND="~net-im/prosody-${PV}"
RDEPEND="
	${DEPEND}
	prosody_modules_inotify-reload? (
		dev-lua/linotify
	)
	prosody_modules_auth-joomla? (
		dev-lua/luadbi
	)
	prosody_modules_lib-ldap? (
		dev-lua/lualdap
	)
	prosody_modules_client-certs? (
		dev-lua/luasec
	)
	prosody_modules_listusers? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_pubsub-pivotaltracker? (
		dev-lua/luaexpat
	)
	prosody_modules_auth-phpbb3? (
		dev-lua/luadbi
	)
	prosody_modules_log-messages-sql? (
		dev-lua/luadbi
	)
	prosody_modules_message-logging? (
		dev-lua/luafilesystem
	)
	prosody_modules_onions? (
		lua_targets_lua5-1? (
			|| (
				dev-lua/LuaBitOp
				dev-lua/lua-bit32
			)
		)
	)
	prosody_modules_couchdb? (
		dev-lua/luasocket
	)
	prosody_modules_auth-custom-http? (
		dev-lua/luasocket
	)
	prosody_modules_checkcerts? (
		dev-lua/luasec
	)
	prosody_modules_auth-internal-yubikey? (
		lua_targets_lua5-1? (
			|| (
				dev-lua/LuaBitOp
				dev-lua/lua-bit32
			)
		)
		dev-lua/yubikey-lua
	)
	prosody_modules_auth-dovecot? (
		dev-lua/luasocket
	)
	prosody_modules_storage-ldap? (
		dev-lua/luasocket
	)
	prosody_modules_statistics? (
		dev-lua/luaposix[ncurses(+)]
	)
	prosody_modules_http-dir-listing? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_log-messages-sql? (
		dev-lua/luasocket
		dev-lua/luadbi
	)
	prosody_modules_storage-mongodb? (
		dev-lua/luamongo
	)
	prosody_modules_offline-email? (
		dev-lua/luasocket
	)
	prosody_modules_auth-wordpress? (
		dev-lua/luadbi
	)
	prosody_modules_muc-log-http? (
		dev-lua/luafilesystem
		dev-lua/luaexpat
	)
	prosody_modules_component-client? (
		dev-lua/luasocket
	)
	prosody_modules_auth-external-insecure? (
		dev-lua/lpc
	)
	prosody_modules_auth-sql? (
		dev-lua/luadbi
	)
"

REQUIRED_USE="
	prosody_modules_auth-ldap? ( prosody_modules_lib-ldap )
	prosody_modules_auth-ldap2? ( prosody_modules_lib-ldap )
"

src_install() {
	cd "${S}";
	use prosody_modules_mam || ewarn "mod-mam is ignored. Using prosody's instead."
	for m in ${PROSODY_MODULES//mam /}; do
		if use prosody_modules_${m}; then
			insinto /usr/lib/prosody/modules;
			doins -r "mod_${m}"
		fi
	done
	use misc && (
		insinto /usr/lib/prosody/modules
		doins -r misc
	)
}

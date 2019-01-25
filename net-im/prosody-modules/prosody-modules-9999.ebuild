# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="https://modules.prosody.im/"
EHG_REPO_URI="https://hg.prosody.im/prosody-modules"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE="misc luajit"

PROSODY_MODULES="
	addressing adhoc_account_management adhoc_blacklist adhoc_dataforms_demo
	adhoc_groups admin_blocklist admin_message admin_probe admin_web alias
	atom auth_any auth_ccert auth_custom_http auth_dovecot auth_external
	auth_ha1 auth_http_async auth_http_cookie auth_imap
	auth_internal_yubikey auth_joomla auth_ldap auth_ldap2 auth_oauthbearer
	auth_pam auth_phpbb3 auth_sql auth_token auth_wordpress
	auto_accept_subscriptions auto_activate_hosts auto_answer_disco_info
	benchmark_storage bidi block_outgoing block_registrations
	block_s2s_subscriptions block_strangers block_subscribes
	block_subscriptions blocking bob bookmarks broadcast c2s_conn_throttle
	c2s_limit_sessions cache_c2s_caps captcha_registration carbons
	carbons_adhoc carbons_copies checkcerts client_certs client_proxy
	cloud_notify compact_resource compat_bind compat_dialback
	compat_muc_admin compat_vcard component_client component_http
	component_roundrobin compression_unsafe conformance_restricted
	conversejs couchdb csi csi_battery_saver csi_compat csi_pump data_access
	default_bookmarks default_vcard delay delegation deny_omemo devices
	disable_tls discoitems dwd e2e_policy email_pass extdisco fallback_vcard
	filter_chatstates filter_words firewall flash_policy graceful_shutdown
	group_bookmarks host_blacklist host_guard host_status_check
	host_status_heartbeat http_altconnect http_auth_check
	http_authentication http_avatar http_dir_listing http_dir_listing2
	http_favicon http_host_status_check http_hostaliases http_index
	http_logging http_muc_log http_pep_avatar http_rest http_roster_admin
	http_stats_stream http_upload http_upload_external http_user_count
	idlecompat ignore_host_chatstates incidents_handling inject_ecaps2
	inotify_reload invite ipcheck isolate_host jid_prep json_streams lastlog
	latex lib_ldap limit_auth limits list_active list_inactive listusers
	log_auth log_events log_http log_mark log_messages_sql log_rate
	log_sasl_mech log_slow_events mam mam_adhoc mam_archive mam_muc mamsub
	manifesto measure_client_features measure_client_identities
	measure_client_presence measure_cpu measure_malloc measure_memory
	measure_message_e2ee measure_message_length measure_stanza_counts
	measure_storage message_logging migrate minimix motd_sequential
	muc_access_control muc_badge muc_ban_ip muc_block_pm muc_cloud_notify
	muc_config_restrict muc_eventsource muc_gc10 muc_intercom muc_lang
	muc_limits muc_log muc_log_http muc_ping muc_restrict_rooms munin
	net_dovecotauth net_proxy offline_email omemo_all_access onhold onions
	openid password_policy password_reset pastebin pep_vcard_avatar
	pep_vcard_png_avatar persisthosts pinger poke_strangers post_msg
	presence_cache presence_dedup privacy_lists private_adhoc privilege
	proctitle profile prometheus proxy65_whitelist pubsub_eventsource
	pubsub_feeds pubsub_github pubsub_hub pubsub_mqtt pubsub_pivotaltracker
	pubsub_post pubsub_stats pubsub_text_interface pubsub_twitter
	query_client_ver rawdebug readonly register_dnsbl
	register_dnsbl_firewall_mark register_dnsbl_warn register_json
	register_oob_url register_redirect register_web reload_components
	reload_modules remote_roster require_otr roster_allinall roster_command
	s2s_auth_compat s2s_auth_dane s2s_auth_fingerprint s2s_auth_monkeysphere
	s2s_auth_posh s2s_auth_samecert s2s_blacklist s2s_idle_timeout
	s2s_keepalive s2s_keysize_policy s2s_log_certs
	s2s_never_encrypt_blacklist s2s_reload_newcomponent s2s_whitelist
	s2soutinjection sasl_oauthbearer saslauth_muc saslname seclabels
	secure_interfaces server_status service_directories sift slack_webhooks
	smacks smacks_noerror smacks_offline sms_clickatell spam_reporting
	srvinjection sslv3_warn stanza_counter stanzadebug statistics
	statistics_auth statistics_cputotal statistics_mem statistics_statsd
	statistics_statsman statsd storage_appendmap
	storage_ejabberdsql_readonly storage_gdbm storage_ldap storage_lmdb
	storage_memory storage_mongodb storage_muc_log
	storage_muconference_readonly storage_multi storage_xmlarchive
	streamstats strict_https support_contact support_room swedishchef
	tcpproxy telnet_tlsinfo test_data throttle_presence throttle_unsolicited
	tls_policy traceback track_muc_joins turncredentials twitter
	uptime_presence vcard_command vcard_muc vjud watchuntrusted webpresence
	xhtmlim
"

for x in ${PROSODY_MODULES}; do
	IUSE="${IUSE} ${x//[^+]/}prosody_modules_${x/+}"
done

DEPEND="~net-im/prosody-${PV}"
RDEPEND="
	${DEPEND}
	prosody_modules_inotify_reload? (
		dev-lua/linotify
	)
	prosody_modules_auth_joomla? (
		dev-lua/luadbi
	)
	prosody_modules_lib_ldap? (
		dev-lua/lualdap
	)
	prosody_modules_client_certs? (
		dev-lua/luasec
	)
	prosody_modules_listusers? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_pubsub_pivotaltracker? (
		dev-lua/luaexpat
	)
	prosody_modules_auth_phpbb3? (
		dev-lua/luadbi
	)
	prosody_modules_log_messages_sql? (
		dev-lua/luadbi
	)
	prosody_modules_message_logging? (
		dev-lua/luafilesystem
	)
	prosody_modules_onions? (
		virtual/lua[bit]
	)
	prosody_modules_couchdb? (
		dev-lua/luasocket
	)
	prosody_modules_auth_custom_http? (
		dev-lua/luasocket
	)
	prosody_modules_checkcerts? (
		dev-lua/luasec
	)
	prosody_modules_auth_internal_yubikey? (
		virtual/lua[bit,luajit=]
		dev-lua/yubikey-lua
	)
	prosody_modules_auth_dovecot? (
		dev-lua/luasocket
	)
	prosody_modules_storage_ldap? (
		dev-lua/luasocket
	)
	prosody_modules_statistics? (
		dev-lua/luaposix[ncurses]
	)
	prosody_modules_http_dir_listing? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_log_messages_sql? (
		dev-lua/luasocket
		dev-lua/luadbi
	)
	prosody_modules_storage_mongodb? (
		dev-lua/luamongo
	)
	prosody_modules_offline_email? (
		dev-lua/luasocket
	)
	prosody_modules_auth_wordpress? (
		dev-lua/luadbi
	)
	prosody_modules_muc_log_http? (
		dev-lua/luafilesystem
		dev-lua/luaexpat
	)
	prosody_modules_component_client? (
		dev-lua/luasocket
	)
	prosody_modules_auth_external? (
		dev-lua/lpc
	)
	prosody_modules_auth_sql? (
		dev-lua/luadbi
	)
"

REQUIRED_USE="
	prosody_modules_auth_ldap? ( prosody_modules_lib_ldap )
	prosody_modules_auth_ldap2? ( prosody_modules_lib_ldap )
"

src_install() {
	cd "${S}";
	use prosody_modules_mam || ewarn "mod_mam is ignored. Using prosody's instead."
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

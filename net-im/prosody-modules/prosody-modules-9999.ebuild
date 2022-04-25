# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="https://modules.prosody.im/"
EHG_REPO_URI="https://hg.prosody.im/prosody-modules"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE="misc luajit"

PROSODY_MODULES="
	addressing adhoc_account_management adhoc_blacklist adhoc_dataforms_demo
	adhoc_groups adhoc_oauth2_client admin_blocklist admin_message
	admin_notify admin_probe admin_web alias atom auth_any auth_ccert
	auth_custom_http auth_cyrus auth_dovecot auth_external_insecure auth_ha1
	auth_http auth_http_async auth_http_cookie auth_imap
	auth_internal_yubikey auth_joomla auth_ldap auth_ldap2 auth_oauthbearer
	auth_pam auth_phpbb3 auth_sql auth_token auth_wordpress auto156
	auto_accept_subscriptions auto_activate_hosts auto_answer_disco_info
	auto_moved aws_profile benchmark_storage bidi bind2 block_outgoing
	block_registrations block_s2s_subscriptions block_strangers
	block_subscribes block_subscriptions blocking bob bookmarks bookmarks2
	broadcast c2s_conn_throttle c2s_limit_sessions cache_c2s_caps
	captcha_registration carbons carbons_adhoc carbons_copies checkcerts
	client_certs client_proxy cloud_notify cloud_notify_encrypted
	cloud_notify_extensions cloud_notify_filters cloud_notify_priority_tag
	compact_resource compat_bind compat_dialback compat_muc_admin
	compat_vcard compliance_2021 component_client component_http
	component_roundrobin compression_unsafe conformance_restricted
	conversejs couchdb csi csi_battery_saver csi_compat csi_grace_period
	csi_muc_priorities csi_simple_compat data_access debug_omemo
	debug_traceback default_bookmarks default_vcard delegation deny_omemo
	devices disable_tls discodot discoitems dnsupdate dwd e2e_policy
	easy_invite email email_pass export_skeletons extdisco external_services
	fallback_vcard file_management filter_chatstates filter_words firewall
	flash_policy graceful_shutdown group_bookmarks groups_internal
	groups_migration groups_muc_bookmarks groups_shell host_blacklist
	host_guard host_status_check host_status_heartbeat http_admin_api
	http_altconnect http_auth_check http_authentication http_avatar
	http_dir_listing http_dir_listing2 http_favicon http_host_status_check
	http_hostaliases http_index http_libjs http_logging http_muc_kick
	http_muc_log http_oauth2 http_pep_avatar http_prebind http_rest
	http_roster_admin http_stats_stream http_upload http_upload_external
	http_user_count http_xep227 idlecompat ignore_host_chatstates
	incidents_handling inject_ecaps2 inotify_reload invite invites
	invites_adhoc invites_api invites_groups invites_page invites_register
	invites_register_api invites_register_web invites_tracking ipcheck
	isolate_host jid_prep json_streams jsxc lastlog lastlog2 latex lib_ldap
	limit_auth limits limits_exception list_active list_inactive listusers
	log_auth log_events log_events_by_cpu_usage log_events_by_memory
	log_http log_json log_mark log_messages_sql log_rate log_ringbuffer
	log_sasl_mech log_slow_events mam mam_adhoc mam_archive mam_muc mamsub
	manifesto map measure_active_users measure_client_features
	measure_client_identities measure_client_presence measure_cpu
	measure_lua measure_malloc measure_memory measure_message_e2ee
	measure_message_length measure_muc measure_process measure_registration
	measure_stanza_counts measure_storage message_logging migrate
	migrate_http_upload minimix motd_sequential muc_access_control
	muc_archive muc_auto_reserve_nicks muc_badge muc_ban_ip
	muc_batched_probe muc_block_pm muc_bot muc_cloud_notify
	muc_config_restrict muc_defaults muc_dicebot muc_eventsource muc_gc10
	muc_hats_adhoc muc_hats_api muc_hide_media muc_http_auth
	muc_http_defaults muc_inject_mentions muc_intercom muc_lang muc_limits
	muc_local_only muc_log muc_log_http muc_mam_hints muc_mam_markers
	muc_markers muc_media_metadata muc_mention_notifications muc_moderation
	muc_notifications muc_occupant_id muc_offline_delivery muc_ping muc_rai
	muc_require_tos muc_restrict_media muc_restrict_nick muc_restrict_rooms
	muc_rtbl muc_search muc_webchat_url munin net_dovecotauth net_proxy
	nodeinfo2 nooffline_noerror offline_email offline_hints ogp
	omemo_all_access onhold onions openid password_policy password_reset
	pastebin pep_atom_categories pep_vcard_avatar pep_vcard_png_avatar
	persisthosts ping_muc pinger poke_strangers portcheck post_msg
	presence_cache presence_dedup privacy_lists private_adhoc privilege
	proctitle profile prometheus proxy65_whitelist pubsub_alertmanager
	pubsub_eventsource pubsub_feeds pubsub_github pubsub_hub pubsub_mqtt
	pubsub_pivotaltracker pubsub_post pubsub_stats pubsub_subscription
	pubsub_summary pubsub_text_interface pubsub_twitter query_client_ver
	rawdebug readonly register_apps register_dnsbl
	register_dnsbl_firewall_mark register_dnsbl_warn register_json
	register_oob_url register_redirect register_web reload_components
	reload_modules reminders remote_roster require_otr rest roster_allinall
	roster_command s2s_auth_compat s2s_auth_dane s2s_auth_fingerprint
	s2s_auth_monkeysphere s2s_auth_posh s2s_auth_samecert s2s_blacklist
	s2s_idle_timeout s2s_keepalive s2s_keysize_policy s2s_log_certs
	s2s_never_encrypt_blacklist s2s_reload_newcomponent s2s_status
	s2s_whitelist s2soutinjection sasl2 sasl_oauthbearer saslauth_muc
	saslname seclabels secure_interfaces sentry server_status
	service_directories sift slack_webhooks smacks smacks_noerror
	smacks_offline sms_clickatell sms_free spam_reporting srvinjection
	sslv3_warn stanza_counter stanzadebug statistics statistics_auth
	statistics_cputotal statistics_mem statistics_statsman stats39 statsd
	storage_appendmap storage_ejabberdsql_readonly storage_gdbm storage_ldap
	storage_lmdb storage_memory storage_mongodb storage_muc_log
	storage_muconference_readonly storage_multi storage_xmlarchive
	streamstats strict_https support_contact support_room swedishchef
	tcpproxy telnet_tlsinfo test_data throttle_presence throttle_unsolicited
	tls_policy tlsfail tos traceback track_muc_joins turn_external
	turncredentials tweet_data twitter uptime_presence vcard_command
	vcard_muc vjud warn_legacy_tls watch_spam_reports watchuntrusted
	webpresence welcome_page xhtmlim
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
		|| (
			dev-lang/luajit
			dev-lua/LuaBitOp
			dev-lua/lua-bit32
			>=dev-lang/lua-5.2
		)
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
		|| (
			dev-lang/luajit
			dev-lua/LuaBitOp
			dev-lua/lua-bit32
			>=dev-lang/lua-5.2
		)
		luajit? ( dev-lang/luajit )
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
	prosody_modules_auth_external_insecure? (
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

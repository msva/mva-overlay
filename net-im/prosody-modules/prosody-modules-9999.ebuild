# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="http://prosody-modules.googlecode.com/"
EHG_REPO_URI="https://prosody-modules.googlecode.com/hg/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="addressing adhoc adhoc_cmd_admin adhoc_cmd_modules adhoc_cmd_ping
	adhoc_cmd_uptime admin_web archive archive_muc auth_dovecot auth_external
	auth_internal_yubikey auth_joomla auth_ldap auth_phpbb3 auth_sql
	auth_wordpress blocking carbons component_guard component_roundrobin
	couchdb data_access default_bookmarks default_vcard discoitems extdisco
	flash_policy group_bookmarks ipcheck ircd json_streams latex log_auth
	motd_sequential muc_intercom muc_log muc_log_http offline_email onhold
	openid pastebin post_msg privacy proxy65 pubsub_feed register_json
	register_redirect reload_modules remote_roster roster_command
	s2s_blackwhitelist s2s_idle_timeout s2s_never_encrypt_blacklist
	s2s_reload_newcomponent saslauth_muc seclabels server_contact_info sift
	smacks sms_clickatell srvinjection stanza_counter streamstats
	support_contact swedishchef tcpproxy throttle_presence twitter webpresence
	websocket"

DEPEND="net-im/prosody
	ircd? ( dev-lua/squish dev-lua/verse )"
RDEPEND="${DEPEND}"

src_install() {
	cd "${S}";
	for m in ${IUSE}; do
		if use ${m}; then
			insinto /usr/lib/prosody/modules;
			doins -r "mod_${m}" || die
		fi
	done
}

pkg_postinst() {
	if use ircd; then
		cd /usr/lib/prosody/modules/mod_ircd;
		cp "$(pkg-config --variable INSTALL_LMOD lua)"/verse.lua verse.lua
		squish --use-http
	fi
}
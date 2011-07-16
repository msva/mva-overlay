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
IUSE="admin_web archive archive_muc auth_dovecot auth_external
	auth_internal_yubikey auth_ldap auth_sql blocking couchdb data_access
	discoitems extdisco group_bookmarks ipcheck ircd json_streams
	latex motd_sequential muc_intercom muc_log muc_log_http offline_email
	onhold openid pastebin post_msg privacy pubsub_feed
	register_json register_url reload_modules remote_roster s2s_blackwhitelist
	s2s_idle_timeout s2s_reload_newcomponent saslauth_muc seclabels sift
	smacks sms_clickatell srvinjection streamstats support_contact swedishchef
	tcpproxy throttle_presence twitter webpresence websocket"

DEPEND="net-im/prosody"
RDEPEND="${DEPEND}"

src_install() {
	cd "${S}";
	for m in ${IUSE}; do
		if use ${m}; then
			insinto "/usr/lib/prosody/modules/mod_${m}";
			doins "mod_${m}"/* || die
		fi
	done
}
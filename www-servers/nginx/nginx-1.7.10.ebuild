# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following 3 requirements in mind before adding external modules:
#   * alive upstream
#   * sane packaging
#   * builds cleanly
# - TODO: test the google-perftools module (included in vanilla tarball)

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"
USE_RUBY="jruby ruby19 ruby20 ruby21 ruby22"
RUBY_OPTIONAL="yes"

# http_passenger (https://github.com/phusion/passenger/tags, MIT license)
HTTP_PASSENGER_MODULE_A="phusion"
HTTP_PASSENGER_MODULE_PN="passenger"
#HTTP_PASSENGER_MODULE_PV="4.0.59"
HTTP_PASSENGER_MODULE_PV="5.0.0.beta3"
#HTTP_PASSENGER_MODULE_SHA="cdd650c95faeeed01ad88c199a5f51bd6e03c49e"
HTTP_PASSENGER_MODULE_P="${HTTP_PASSENGER_MODULE_PN}-${HTTP_PASSENGER_MODULE_SHA:-release-${HTTP_PASSENGER_MODULE_PV}}"
HTTP_PASSENGER_MODULE_URI="https://github.com/${HTTP_PASSENGER_MODULE_A}/${HTTP_PASSENGER_MODULE_PN}/archive/${HTTP_PASSENGER_MODULE_SHA:-release-${HTTP_PASSENGER_MODULE_PV}}.tar.gz"
HTTP_PASSENGER_MODULE_WD="${WORKDIR}/${HTTP_PASSENGER_MODULE_P}/ext/nginx"

# http_pagespeed (https://github.com/pagespeed/ngx_pagespeed/tags, BSD-2 license)
HTTP_PAGESPEED_MODULE_A="pagespeed"
HTTP_PAGESPEED_MODULE_PN="ngx_pagespeed"
HTTP_PAGESPEED_MODULE_PV="1.9.32.3-beta"
#HTTP_PAGESPEED_MODULE_SHA="1c5b61679cc47716930399516e188e1e896060dd"
HTTP_PAGESPEED_MODULE_P="${HTTP_PAGESPEED_MODULE_PN}-${HTTP_PAGESPEED_MODULE_SHA:-${HTTP_PAGESPEED_MODULE_PV}}"
HTTP_PAGESPEED_MODULE_URI="https://github.com/${HTTP_PAGESPEED_MODULE_A}/${HTTP_PAGESPEED_MODULE_PN}/archive/${HTTP_PAGESPEED_MODULE_SHA:-v${HTTP_PAGESPEED_MODULE_PV}}.tar.gz"
HTTP_PAGESPEED_MODULE_WD="${WORKDIR}/${HTTP_PAGESPEED_MODULE_P}"

HTTP_PAGESPEED_PSOL_PN="psol"
HTTP_PAGESPEED_PSOL_PV="1.9.32.3"
HTTP_PAGESPEED_PSOL_P="${HTTP_PAGESPEED_PSOL_PN}-${HTTP_PAGESPEED_PSOL_SHA:-${HTTP_PAGESPEED_PSOL_PV}}"
HTTP_PAGESPEED_PSOL_URI="https://dl.google.com/dl/page-speed/${HTTP_PAGESPEED_PSOL_PN}/${HTTP_PAGESPEED_PSOL_PV}.tar.gz"
HTTP_PAGESPEED_PSOL_WD="../${HTTP_PAGESPEED_PSOL_PN}"

# http_hls_audio (https://github.com/flavioribeiro/nginx-audio-track-for-hls-module/tags, BSD-2 license)
HTTP_HLS_AUDIO_MODULE_A="flavioribeiro"
HTTP_HLS_AUDIO_MODULE_PN="nginx-audio-track-for-hls-module"
HTTP_HLS_AUDIO_MODULE_PV="0.2"
HTTP_HLS_AUDIO_MODULE_SHA="1e8f2208e243971427154392b855fd973bfedbed"
HTTP_HLS_AUDIO_MODULE_P="${HTTP_HLS_AUDIO_MODULE_PN}-${HTTP_HLS_AUDIO_MODULE_SHA:-${HTTP_HLS_AUDIO_MODULE_PV}}"
HTTP_HLS_AUDIO_MODULE_URI="https://github.com/${HTTP_HLS_AUDIO_MODULE_A}/${HTTP_HLS_AUDIO_MODULE_PN}/archive/${HTTP_HLS_AUDIO_MODULE_SHA:-${HTTP_HLS_AUDIO_MODULE_PV}}.tar.gz"
HTTP_HLS_AUDIO_MODULE_WD="${WORKDIR}/${HTTP_HLS_AUDIO_MODULE_P}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module/tags, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_A="masterzen"
HTTP_UPLOAD_PROGRESS_MODULE_PN="nginx-upload-progress-module"
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.1"
HTTP_UPLOAD_PROGRESS_MODULE_P="${HTTP_UPLOAD_PROGRESS_MODULE_PN}-${HTTP_UPLOAD_PROGRESS_MODULE_SHA:-${HTTP_UPLOAD_PROGRESS_MODULE_PV}}"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/${HTTP_UPLOAD_PROGRESS_MODULE_A}/${HTTP_UPLOAD_PROGRESS_MODULE_PN}/archive/${HTTP_UPLOAD_PROGRESS_MODULE_SHA:-v${HTTP_UPLOAD_PROGRESS_MODULE_PV}}.tar.gz"
HTTP_UPLOAD_PROGRESS_MODULE_WD="${WORKDIR}/${HTTP_UPLOAD_PROGRESS_MODULE_P}"

# http_headers_more (https://github.com/openresty/headers-more-nginx-module/tags, BSD license)
HTTP_HEADERS_MORE_MODULE_A="openresty"
HTTP_HEADERS_MORE_MODULE_PN="headers-more-nginx-module"
HTTP_HEADERS_MORE_MODULE_PV="0.25"
HTTP_HEADERS_MORE_MODULE_P="${HTTP_HEADERS_MORE_MODULE_PN}-${HTTP_HEADERS_MORE_MODULE_SHA:-${HTTP_HEADERS_MORE_MODULE_PV}}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/${HTTP_HEADERS_MORE_MODULE_A}/${HTTP_HEADERS_MORE_MODULE_PN}/archive/${HTTP_HEADERS_MORE_MODULE_SHA:-v${HTTP_HEADERS_MORE_MODULE_PV}}.tar.gz"
HTTP_HEADERS_MORE_MODULE_WD="${WORKDIR}/${HTTP_HEADERS_MORE_MODULE_P}"

# http_encrypted_session (https://github.com/openresty/encrypted-session-nginx-module/tags, BSD license)
HTTP_ENCRYPTED_SESSION_MODULE_A="openresty"
HTTP_ENCRYPTED_SESSION_MODULE_PN="encrypted-session-nginx-module"
HTTP_ENCRYPTED_SESSION_MODULE_PV="0.03"
HTTP_ENCRYPTED_SESSION_MODULE_P="${HTTP_ENCRYPTED_SESSION_MODULE_PN}-${HTTP_ENCRYPTED_SESSION_MODULE_SHA:-${HTTP_ENCRYPTED_SESSION_MODULE_PV}}"
HTTP_ENCRYPTED_SESSION_MODULE_URI="https://github.com/${HTTP_ENCRYPTED_SESSION_MODULE_A}/${HTTP_ENCRYPTED_SESSION_MODULE_PN}/archive/${HTTP_ENCRYPTED_SESSION_MODULE_SHA:-v${HTTP_ENCRYPTED_SESSION_MODULE_PV}}.tar.gz"
HTTP_ENCRYPTED_SESSION_MODULE_WD="${WORKDIR}/${HTTP_ENCRYPTED_SESSION_MODULE_P}"

# http_push_stream (https://github.com/wandenberg/nginx-push-stream-module/tags, BSD license)
HTTP_PUSH_STREAM_MODULE_A="wandenberg"
HTTP_PUSH_STREAM_MODULE_PN="nginx-push-stream-module"
HTTP_PUSH_STREAM_MODULE_PV="0.4.1"
HTTP_PUSH_STREAM_MODULE_P="${HTTP_PUSH_STREAM_MODULE_PN}-${HTTP_PUSH_STREAM_MODULE_SHA:-${HTTP_PUSH_STREAM_MODULE_PV}}"
HTTP_PUSH_STREAM_MODULE_URI="https://github.com/${HTTP_PUSH_STREAM_MODULE_A}/${HTTP_PUSH_STREAM_MODULE_PN}/archive/${HTTP_PUSH_STREAM_MODULE_PV}.tar.gz"
HTTP_PUSH_STREAM_MODULE_WD="${WORKDIR}/${HTTP_PUSH_STREAM_MODULE_P}"

# http_ctpp2 (http://ngx-ctpp.vbart.ru/ (ru) http://ngx-ctpp.vbart.info/ (en), BSD license)
HTTP_CTPP_MODULE_PV="0.5"
HTTP_CTPP_MODULE_P="ngx_ctpp2-${HTTP_CTPP_MODULE_PV}"
HTTP_CTPP_MODULE_URI="http://dl.vbart.ru/ngx-ctpp/${HTTP_CTPP_MODULE_P}.tar.gz"
HTTP_CTPP_MODULE_WD="${WORKDIR}/${HTTP_CTPP_MODULE_P}"

# http_cache_purge (https://github.com/FRiCKLE/ngx_cache_purge/tags, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_A="FRiCKLE"
HTTP_CACHE_PURGE_MODULE_PN="ngx_cache_purge"
HTTP_CACHE_PURGE_MODULE_PV="2.3"
HTTP_CACHE_PURGE_MODULE_P="${HTTP_CACHE_PURGE_MODULE_PN}-${HTTP_CACHE_PURGE_MODULE_SHA:-${HTTP_CACHE_PURGE_MODULE_PV}}"
HTTP_CACHE_PURGE_MODULE_URI="https://github.com/${HTTP_CACHE_PURGE_MODULE_A}/${HTTP_CACHE_PURGE_MODULE_PN}/archive/${HTTP_CACHE_PURGE_MODULE_PV}.tar.gz"
HTTP_CACHE_PURGE_MODULE_WD="${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"

# ey-balancer/maxconn module (https://github.com/msva/nginx-ey-balancer/tags, as-is)
HTTP_EY_BALANCER_MODULE_A="msva"
HTTP_EY_BALANCER_MODULE_PN="nginx-ey-balancer"
HTTP_EY_BALANCER_MODULE_PV="0.0.8"
HTTP_EY_BALANCER_MODULE_P="${HTTP_EY_BALANCER_MODULE_PN}-${HTTP_EY_BALANCER_MODULE_SHA:-${HTTP_EY_BALANCER_MODULE_PV}}"
HTTP_EY_BALANCER_MODULE_URI="https://github.com/${HTTP_EY_BALANCER_MODULE_A}/${HTTP_EY_BALANCER_MODULE_PN}/archive/${HTTP_EY_BALANCER_MODULE_SHA:-v${HTTP_EY_BALANCER_MODULE_PV}}.tar.gz"
HTTP_EY_BALANCER_MODULE_WD="${WORKDIR}/${HTTP_EY_BALANCER_MODULE_P}"

# NginX DevKit module (https://github.com/simpl/ngx_devel_kit/tags, BSD)
HTTP_NDK_MODULE_A="simpl"
HTTP_NDK_MODULE_PN="ngx_devel_kit"
HTTP_NDK_MODULE_PV="0.2.19"
HTTP_NDK_MODULE_P="${HTTP_NDK_MODULE_PN}-${HTTP_NDK_MODULE_SHA:-${HTTP_NDK_MODULE_PV}}"
HTTP_NDK_MODULE_URI="https://github.com/${HTTP_NDK_MODULE_A}/${HTTP_NDK_MODULE_PN}/archive/${HTTP_NDK_MODULE_SHA:-v${HTTP_NDK_MODULE_PV}}.tar.gz"
HTTP_NDK_MODULE_WD="${WORKDIR}/${HTTP_NDK_MODULE_P}"

# NginX Lua module (https://github.com/openresty/lua-nginx-module/tags, BSD)
HTTP_LUA_MODULE_A="openresty"
HTTP_LUA_MODULE_PN="lua-nginx-module"
HTTP_LUA_MODULE_PV="0.9.14"
#HTTP_LUA_MODULE_SHA="25c4bdd6b68e54f241fff9018ec4aa7a65426b31"
HTTP_LUA_MODULE_P="${HTTP_LUA_MODULE_PN}-${HTTP_LUA_MODULE_SHA:-${HTTP_LUA_MODULE_PV}}"
HTTP_LUA_MODULE_URI="https://github.com/${HTTP_LUA_MODULE_A}/${HTTP_LUA_MODULE_PN}/archive/${HTTP_LUA_MODULE_SHA:-v${HTTP_LUA_MODULE_PV}}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/${HTTP_LUA_MODULE_P}"

# NginX Drizzle module (https://github.com/openresty/drizzle-nginx-module/tags, BSD)
HTTP_DRIZZLE_MODULE_A="openresty"
HTTP_DRIZZLE_MODULE_PN="drizzle-nginx-module"
HTTP_DRIZZLE_MODULE_PV="0.1.8"
HTTP_DRIZZLE_MODULE_P="${HTTP_DRIZZLE_MODULE_PN}-${HTTP_DRIZZLE_MODULE_SHA:-${HTTP_DRIZZLE_MODULE_PV}}"
HTTP_DRIZZLE_MODULE_URI="https://github.com/${HTTP_DRIZZLE_MODULE_A}/${HTTP_DRIZZLE_MODULE_PN}/archive/${HTTP_DRIZZLE_MODULE_SHA:-v${HTTP_DRIZZLE_MODULE_PV}}.tar.gz"
HTTP_DRIZZLE_MODULE_WD="${WORKDIR}/${HTTP_DRIZZLE_MODULE_P}"

# NginX form-input module (https://github.com/calio/form-input-nginx-module/tags, BSD)
HTTP_FORM_INPUT_MODULE_A="calio"
HTTP_FORM_INPUT_MODULE_PN="form-input-nginx-module"
HTTP_FORM_INPUT_MODULE_PV="0.10"
HTTP_FORM_INPUT_MODULE_P="${HTTP_FORM_INPUT_MODULE_PN}-${HTTP_FORM_INPUT_MODULE_SHA:-${HTTP_FORM_INPUT_MODULE_PV}}"
HTTP_FORM_INPUT_MODULE_URI="https://github.com/${HTTP_FORM_INPUT_MODULE_A}/${HTTP_FORM_INPUT_MODULE_PN}/archive/${HTTP_FORM_INPUT_MODULE_SHA:-v${HTTP_FORM_INPUT_MODULE_PV}}.tar.gz"
HTTP_FORM_INPUT_MODULE_WD="${WORKDIR}/${HTTP_FORM_INPUT_MODULE_P}"

# NginX echo module (https://github.com/openresty/echo-nginx-module/tags, BSD)
HTTP_ECHO_MODULE_A="openresty"
HTTP_ECHO_MODULE_PN="echo-nginx-module"
HTTP_ECHO_MODULE_PV="0.57"
HTTP_ECHO_MODULE_P="${HTTP_ECHO_MODULE_PN}-${HTTP_ECHO_MODULE_SHA:-${HTTP_ECHO_MODULE_PV}}"
HTTP_ECHO_MODULE_URI="https://github.com/${HTTP_ECHO_MODULE_A}/${HTTP_ECHO_MODULE_PN}/archive/${HTTP_ECHO_MODULE_SHA:-v${HTTP_ECHO_MODULE_PV}}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/${HTTP_ECHO_MODULE_P}"

# NginX Featured mecached module (https://github.com/openresty/memc-nginx-module/tags, BSD)
HTTP_MEMC_MODULE_A="openresty"
HTTP_MEMC_MODULE_PN="memc-nginx-module"
HTTP_MEMC_MODULE_PV="0.15"
HTTP_MEMC_MODULE_P="${HTTP_MEMC_MODULE_PN}-${HTTP_MEMC_MODULE_SHA:-${HTTP_MEMC_MODULE_PV}}"
HTTP_MEMC_MODULE_URI="https://github.com/${HTTP_MEMC_MODULE_A}/${HTTP_MEMC_MODULE_PN}/archive/${HTTP_MEMC_MODULE_SHA:-v${HTTP_MEMC_MODULE_PV}}.tar.gz"
HTTP_MEMC_MODULE_WD="${WORKDIR}/${HTTP_MEMC_MODULE_P}"

# NginX RDS-JSON module (https://github.com/openresty/rds-json-nginx-module/tags, BSD)
HTTP_RDS_JSON_MODULE_A="openresty"
HTTP_RDS_JSON_MODULE_PN="rds-json-nginx-module"
HTTP_RDS_JSON_MODULE_PV="0.13"
HTTP_RDS_JSON_MODULE_P="${HTTP_RDS_JSON_MODULE_PN}-${HTTP_RDS_JSON_MODULE_SHA:-${HTTP_RDS_JSON_MODULE_PV}}"
HTTP_RDS_JSON_MODULE_URI="https://github.com/${HTTP_RDS_JSON_MODULE_A}/${HTTP_RDS_JSON_MODULE_PN}/archive/${HTTP_RDS_JSON_MODULE_SHA:-v${HTTP_RDS_JSON_MODULE_PV}}.tar.gz"
HTTP_RDS_JSON_MODULE_WD="${WORKDIR}/${HTTP_RDS_JSON_MODULE_P}"

# NginX RDS-CSV module (https://github.com/openresty/rds-csv-nginx-module/tags, BSD)
HTTP_RDS_CSV_MODULE_A="openresty"
HTTP_RDS_CSV_MODULE_PN="rds-csv-nginx-module"
HTTP_RDS_CSV_MODULE_PV="0.05"
HTTP_RDS_CSV_MODULE_P="${HTTP_RDS_CSV_MODULE_PN}-${HTTP_RDS_CSV_MODULE_SHA:-${HTTP_RDS_CSV_MODULE_PV}}"
HTTP_RDS_CSV_MODULE_URI="https://github.com/${HTTP_RDS_CSV_MODULE_A}/${HTTP_RDS_CSV_MODULE_PN}/archive/${HTTP_RDS_CSV_MODULE_SHA:-v${HTTP_RDS_CSV_MODULE_PV}}.tar.gz"
HTTP_RDS_CSV_MODULE_WD="${WORKDIR}/${HTTP_RDS_CSV_MODULE_P}"

# NginX SRCache module (https://github.com/openresty/srcache-nginx-module/tags, BSD)
HTTP_SRCACHE_MODULE_A="openresty"
HTTP_SRCACHE_MODULE_PN="srcache-nginx-module"
HTTP_SRCACHE_MODULE_PV="0.28"
HTTP_SRCACHE_MODULE_P="${HTTP_SRCACHE_MODULE_PN}-${HTTP_SRCACHE_MODULE_SHA:-${HTTP_SRCACHE_MODULE_PV}}"
HTTP_SRCACHE_MODULE_URI="https://github.com/${HTTP_SRCACHE_MODULE_A}/${HTTP_SRCACHE_MODULE_PN}/archive/${HTTP_SRCACHE_MODULE_SHA:-v${HTTP_SRCACHE_MODULE_PV}}.tar.gz"
HTTP_SRCACHE_MODULE_WD="${WORKDIR}/${HTTP_SRCACHE_MODULE_P}"

# NginX Set-Misc module (https://github.com/openresty/set-misc-nginx-module/tags, BSD)
HTTP_SET_MISC_MODULE_A="openresty"
HTTP_SET_MISC_MODULE_PN="set-misc-nginx-module"
HTTP_SET_MISC_MODULE_PV="0.28"
HTTP_SET_MISC_MODULE_P="${HTTP_SET_MISC_MODULE_PN}-${HTTP_SET_MISC_MODULE_SHA:-${HTTP_SET_MISC_MODULE_PV}}"
HTTP_SET_MISC_MODULE_URI="https://github.com/${HTTP_SET_MISC_MODULE_A}/${HTTP_SET_MISC_MODULE_PN}/archive/${HTTP_SET_MISC_MODULE_SHA:-v${HTTP_SET_MISC_MODULE_PV}}.tar.gz"
HTTP_SET_MISC_MODULE_WD="${WORKDIR}/${HTTP_SET_MISC_MODULE_P}"

# NginX XSS module (https://github.com/openresty/xss-nginx-module/tags, BSD)
HTTP_XSS_MODULE_A="openresty"
HTTP_XSS_MODULE_PN="xss-nginx-module"
HTTP_XSS_MODULE_PV="0.04"
HTTP_XSS_MODULE_P="${HTTP_XSS_MODULE_PN}-${HTTP_XSS_MODULE_SHA:-${HTTP_XSS_MODULE_PV}}"
HTTP_XSS_MODULE_URI="https://github.com/${HTTP_XSS_MODULE_A}/${HTTP_XSS_MODULE_PN}/archive/${HTTP_XSS_MODULE_SHA:-v${HTTP_XSS_MODULE_PV}}.tar.gz"
HTTP_XSS_MODULE_WD="${WORKDIR}/${HTTP_XSS_MODULE_P}"

# NginX Array-Var module (https://github.com/openresty/array-var-nginx-module/tags, BSD)
HTTP_ARRAY_VAR_MODULE_A="openresty"
HTTP_ARRAY_VAR_MODULE_PN="array-var-nginx-module"
HTTP_ARRAY_VAR_MODULE_PV="0.03"
HTTP_ARRAY_VAR_MODULE_P="${HTTP_ARRAY_VAR_MODULE_PN}-${HTTP_ARRAY_VAR_MODULE_SHA:-${HTTP_ARRAY_VAR_MODULE_PV}}"
HTTP_ARRAY_VAR_MODULE_URI="https://github.com/${HTTP_ARRAY_VAR_MODULE_A}/${HTTP_ARRAY_VAR_MODULE_PN}/archive/${HTTP_ARRAY_VAR_MODULE_SHA:-v${HTTP_ARRAY_VAR_MODULE_PV}}.tar.gz"
HTTP_ARRAY_VAR_MODULE_WD="${WORKDIR}/${HTTP_ARRAY_VAR_MODULE_P}"

# NginX Lua-Upstream module (https://github.com/openresty/lua-upstream-nginx-module/tags, BSD)
HTTP_LUA_UPSTREAM_MODULE_A="openresty"
HTTP_LUA_UPSTREAM_MODULE_PN="lua-upstream-nginx-module"
HTTP_LUA_UPSTREAM_MODULE_PV="0.02"
HTTP_LUA_UPSTREAM_MODULE_P="${HTTP_LUA_UPSTREAM_MODULE_PN}-${HTTP_LUA_UPSTREAM_MODULE_SHA:-${HTTP_LUA_UPSTREAM_MODULE_PV}}"
HTTP_LUA_UPSTREAM_MODULE_URI="https://github.com/${HTTP_LUA_UPSTREAM_MODULE_A}/${HTTP_LUA_UPSTREAM_MODULE_PN}/archive/${HTTP_LUA_UPSTREAM_MODULE_SHA:-v${HTTP_LUA_UPSTREAM_MODULE_PV}}.tar.gz"
HTTP_LUA_UPSTREAM_MODULE_WD="${WORKDIR}/${HTTP_LUA_UPSTREAM_MODULE_P}"

# NginX replace filter module (https://github.com/openresty/replace-filter-nginx-module/tags, BSD)
HTTP_REPLACE_FILTER_MODULE_A="openresty"
HTTP_REPLACE_FILTER_MODULE_PN="replace-filter-nginx-module"
HTTP_REPLACE_FILTER_MODULE_PV="0.01rc5"
HTTP_REPLACE_FILTER_MODULE_P="${HTTP_REPLACE_FILTER_MODULE_PN}-${HTTP_REPLACE_FILTER_MODULE_SHA:-${HTTP_REPLACE_FILTER_MODULE_PV}}"
HTTP_REPLACE_FILTER_MODULE_URI="https://github.com/${HTTP_REPLACE_FILTER_MODULE_A}/${HTTP_REPLACE_FILTER_MODULE_PN}/archive/${HTTP_REPLACE_FILTER_MODULE_SHA:-v${HTTP_REPLACE_FILTER_MODULE_PV}}.tar.gz"
HTTP_REPLACE_FILTER_MODULE_WD="${WORKDIR}/${HTTP_REPLACE_FILTER_MODULE_P}"

# NginX Iconv module (https://github.com/calio/iconv-nginx-module/tags, BSD)
HTTP_ICONV_MODULE_A="calio"
HTTP_ICONV_MODULE_PN="iconv-nginx-module"
HTTP_ICONV_MODULE_PV="0.10"
HTTP_ICONV_MODULE_P="${HTTP_ICONV_MODULE_PN}-${HTTP_ICONV_MODULE_SHA:-${HTTP_ICONV_MODULE_PV}}"
HTTP_ICONV_MODULE_URI="https://github.com/${HTTP_ICONV_MODULE_A}/${HTTP_ICONV_MODULE_PN}/archive/${HTTP_ICONV_MODULE_SHA:-v${HTTP_ICONV_MODULE_PV}}.tar.gz"
HTTP_ICONV_MODULE_WD="${WORKDIR}/${HTTP_ICONV_MODULE_P}"

# NginX postgres module (https://github.com/FRiCKLE/ngx_postgres/tags, BSD-2)
HTTP_POSTGRES_MODULE_A="FRiCKLE"
HTTP_POSTGRES_MODULE_PN="ngx_postgres"
HTTP_POSTGRES_MODULE_PV="1.0rc5"
#HTTP_POSTGRES_MODULE_SHA="f9479fbebe09a7e24ed28833033a0406c4a6f000"
HTTP_POSTGRES_MODULE_P="${HTTP_POSTGRES_MODULE_PN}-${HTTP_POSTGRES_MODULE_SHA:-${HTTP_POSTGRES_MODULE_PV}}"
HTTP_POSTGRES_MODULE_URI="https://github.com/${HTTP_POSTGRES_MODULE_A}/${HTTP_POSTGRES_MODULE_PN}/archive/${HTTP_POSTGRES_MODULE_SHA:-${HTTP_POSTGRES_MODULE_PV}}.tar.gz"
HTTP_POSTGRES_MODULE_WD="${WORKDIR}/${HTTP_POSTGRES_MODULE_P}"

# NginX coolkit module (https://github.com/FRiCKLE/ngx_coolkit/tags, BSD-2)
HTTP_COOLKIT_MODULE_A="FRiCKLE"
HTTP_COOLKIT_MODULE_PN="ngx_coolkit"
HTTP_COOLKIT_MODULE_PV="0.2rc2"
HTTP_COOLKIT_MODULE_P="${HTTP_COOLKIT_MODULE_PN}-${HTTP_COOLKIT_MODULE_SHA:-${HTTP_COOLKIT_MODULE_PV}}"
HTTP_COOLKIT_MODULE_URI="https://github.com/${HTTP_COOLKIT_MODULE_A}/${HTTP_COOLKIT_MODULE_PN}/archive/${HTTP_COOLKIT_MODULE_SHA:-${HTTP_COOLKIT_MODULE_PV}}.tar.gz"
HTTP_COOLKIT_MODULE_WD="${WORKDIR}/${HTTP_COOLKIT_MODULE_P}"

# NginX Supervisord module (http://labs.frickle.com/nginx_ngx_supervisord/, BSD-2)
HTTP_SUPERVISORD_MODULE_PV="1.4"
HTTP_SUPERVISORD_MODULE_P="ngx_supervisord-${HTTP_SUPERVISORD_MODULE_PV}"
HTTP_SUPERVISORD_MODULE_URI="http://labs.frickle.com/files/${HTTP_SUPERVISORD_MODULE_P}.tar.gz"
HTTP_SUPERVISORD_MODULE_WD="${WORKDIR}/${HTTP_SUPERVISORD_MODULE_P}"

# http_slowfs_cache (https://github.com/FRiCKLE/ngx_slowfs_cache/tags, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_A="FRiCKLE"
HTTP_SLOWFS_CACHE_MODULE_PN="ngx_slowfs_cache"
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="${HTTP_SLOWFS_CACHE_MODULE_PN}-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="https://github.com/${HTTP_SLOWFS_CACHE_MODULE_A}/${HTTP_SLOWFS_CACHE_MODULE_PN}/archive/${HTTP_SLOWFS_CACHE_MODULE_SHA:-${HTTP_SLOWFS_CACHE_MODULE_PV}}.tar.gz"
HTTP_SLOWFS_CACHE_MODULE_WD="${WORKDIR}/${HTTP_SLOWFS_CACHE_MODULE_P}"

# http_fancyindex (https://github.com/aperezdc/ngx-fancyindex/tags , BSD license)
HTTP_FANCYINDEX_MODULE_A="aperezdc"
HTTP_FANCYINDEX_MODULE_PN="ngx-fancyindex"
HTTP_FANCYINDEX_MODULE_PV="0.3.5"
HTTP_FANCYINDEX_MODULE_P="${HTTP_FANCYINDEX_MODULE_PN}-${HTTP_FANCYINDEX_MODULE_SHA:-${HTTP_FANCYINDEX_MODULE_PV}}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/${HTTP_FANCYINDEX_MODULE_A}/${HTTP_FANCYINDEX_MODULE_PN}/archive/${HTTP_FANCYINDEX_MODULE_SHA:-v${HTTP_FANCYINDEX_MODULE_PV}}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/${HTTP_FANCYINDEX_MODULE_P}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module/tags, BSD license)
HTTP_UPSTREAM_CHECK_MODULE_A="yaoweibin"
HTTP_UPSTREAM_CHECK_MODULE_PN="nginx_upstream_check_module"
HTTP_UPSTREAM_CHECK_MODULE_PV="0.3.0"
HTTP_UPSTREAM_CHECK_MODULE_P="${HTTP_UPSTREAM_CHECK_MODULE_PN}-${HTTP_UPSTREAM_CHECK_MODULE_SHA:-${HTTP_UPSTREAM_CHECK_MODULE_PV}}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/${HTTP_UPSTREAM_CHECK_MODULE_A}/${HTTP_UPSTREAM_CHECK_MODULE_PN}/archive/${HTTP_UPSTREAM_CHECK_MODULE_SHA:-v${HTTP_UPSTREAM_CHECK_MODULE_PV}}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/${HTTP_UPSTREAM_CHECK_MODULE_P}"

# http_metrics (https://github.com/madvertise/ngx_metrics/tags, BSD license)
HTTP_METRICS_MODULE_A="madvertise"
HTTP_METRICS_MODULE_PN="ngx_metrics"
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="${HTTP_METRICS_MODULE_PN}-${HTTP_METRICS_MODULE_SHA:-${HTTP_METRICS_MODULE_PV}}"
HTTP_METRICS_MODULE_URI="https://github.com/${HTTP_METRICS_MODULE_A}/${HTTP_METRICS_MODULE_PN}/archive/${HTTP_METRICS_MODULE_SHA:-v${HTTP_METRICS_MODULE_PV}}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/${HTTP_METRICS_MODULE_P}"

# naxsi-core (https://github.com/nbs-system/naxsi/tags, GPLv2+)
HTTP_NAXSI_MODULE_A="nbs-system"
HTTP_NAXSI_MODULE_PV="0.53-2"
HTTP_NAXSI_MODULE_PN="naxsi"
HTTP_NAXSI_MODULE_P="${HTTP_NAXSI_MODULE_PN}-${HTTP_NAXSI_MODULE_SHA:-${HTTP_NAXSI_MODULE_PV}}"
HTTP_NAXSI_MODULE_URI="https://github.com/${HTTP_NAXSI_MODULE_A}/${HTTP_NAXSI_MODULE_PN}/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/${HTTP_NAXSI_MODULE_P}/naxsi_src"

# nginx-dav-ext-module (http://github.com/arut/nginx-dav-ext-module/tags, BSD license)
HTTP_DAV_EXT_MODULE_A="arut"
HTTP_DAV_EXT_MODULE_PN="nginx-dav-ext-module"
HTTP_DAV_EXT_MODULE_PV="0.0.3"
HTTP_DAV_EXT_MODULE_P="${HTTP_DAV_EXT_MODULE_PN}-${HTTP_DAV_EXT_MODULE_SHA:-${HTTP_DAV_EXT_MODULE_PV}}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/${HTTP_DAV_EXT_MODULE_A}/${HTTP_DAV_EXT_MODULE_PN}/archive/${HTTP_DAV_EXT_MODULE_SHA:-v${HTTP_DAV_EXT_MODULE_PV}}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/${HTTP_DAV_EXT_MODULE_P}"

# nginx-rtmp-module (http://github.com/arut/nginx-rtmp-module/tags, BSD license)
RTMP_MODULE_A="arut"
RTMP_MODULE_PN="nginx-rtmp-module"
RTMP_MODULE_PV="1.1.6"
#RTMP_MODULE_SHA="5fb4c99ca93442c571354af6a40a4f3ef736af57"
RTMP_MODULE_P="${RTMP_MODULE_PN}-${RTMP_MODULE_SHA:-${RTMP_MODULE_PV}}"
RTMP_MODULE_URI="https://github.com/${RTMP_MODULE_A}/${RTMP_MODULE_PN}/archive/${RTMP_MODULE_SHA:-v${RTMP_MODULE_PV}}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/${RTMP_MODULE_P}"

# mod_security for nginx (https://github.com/SpiderLabs/ModSecurity/tags, Apache-2.0)
HTTP_SECURITY_MODULE_A="SpiderLabs"
HTTP_SECURITY_MODULE_PN="ModSecurity"
HTTP_SECURITY_MODULE_PV="2.9.0"
HTTP_SECURITY_MODULE_P="${HTTP_SECURITY_MODULE_PN}-${HTTP_SECURITY_MODULE_SHA:-${HTTP_SECURITY_MODULE_PV}}"
HTTP_SECURITY_MODULE_URI="https://github.com/${HTTP_SECURITY_MODULE_A}/${HTTP_SECURITY_MODULE_PN}/archive/${HTTP_SECURITY_MODULE_SHA:-v${HTTP_SECURITY_MODULE_PV}}.tar.gz"
HTTP_SECURITY_MODULE_WD="${WORKDIR}/${HTTP_SECURITY_MODULE_P}"

# http_auth_pam (http://web.iti.upv.es/~sto/nginx/, BSD-2 license)
HTTP_AUTH_PAM_MODULE_PN="ngx_http_auth_pam_module"
HTTP_AUTH_PAM_MODULE_PV="1.3"
HTTP_AUTH_PAM_MODULE_P="${HTTP_AUTH_PAM_MODULE_PN}-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="http://web.iti.upv.es/~sto/nginx/${HTTP_AUTH_PAM_MODULE_P}.tgz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/${HTTP_AUTH_PAM_MODULE_P}"

RRD_MODULE_PV="0.2.0"
RRD_MODULE_P="mod_rrd_graph-${RRD_MODULE_PV}"
RRD_MODULE_URI="http://wiki.nginx.org/images/9/9d/${RRD_MODULE_P/m/M}.tar.gz"
RRD_MODULE_WD="${WORKDIR}/${RRD_MODULE_P}"

# sticky-module (https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/downloads#tag-downloads, BSD-2)
HTTP_STICKY_MODULE_A="nginx-goodies"
HTTP_STICKY_MODULE_PN="nginx-sticky-module-ng"
HTTP_STICKY_MODULE_PV="1.2.5"
HTTP_STICKY_MODULE_PV_SHA="bd312d586752"
HTTP_STICKY_MODULE_P="${HTTP_STICKY_MODULE_PN}-${HTTP_STICKY_MODULE_PV}"
HTTP_STICKY_MODULE_URI="https://bitbucket.org/${HTTP_STICKY_MODULE_A}/${HTTP_STICKY_MODULE_PN}/get/${HTTP_STICKY_MODULE_PV}.tar.gz"
HTTP_STICKY_MODULE_WD="${WORKDIR}/${HTTP_STICKY_MODULE_A}-${HTTP_STICKY_MODULE_PN}-${HTTP_STICKY_MODULE_PV_SHA}"

# ajp-module (https://github.com/yaoweibin/nginx_ajp_module/tags, BSD-2)
HTTP_AJP_MODULE_A="yaoweibin"
HTTP_AJP_MODULE_PN="nginx_ajp_module"
HTTP_AJP_MODULE_PV="0.3.0"
HTTP_AJP_MODULE_P="${HTTP_AJP_MODULE_PN}-${HTTP_AJP_MODULE_SHA:-${HTTP_AJP_MODULE_PV}}"
HTTP_AJP_MODULE_URI="https://github.com/yaoweibin/nginx_ajp_module/archive/${HTTP_AJP_MODULE_SHA:-v${HTTP_AJP_MODULE_PV}}.tar.gz"
HTTP_AJP_MODULE_WD="${WORKDIR}/${HTTP_AJP_MODULE_P}"

# mogilefs-module (http://www.grid.net.ru/nginx/mogilefs.en.html, BSD-2)
HTTP_MOGILEFS_MODULE_PN="ngx_mogilefs_module"
HTTP_MOGILEFS_MODULE_PV="1.0.4"
HTTP_MOGILEFS_MODULE_P="${HTTP_MOGILEFS_MODULE_PN}-${HTTP_MOGILEFS_MODULE_PV}"
HTTP_MOGILEFS_MODULE_URI="http://www.grid.net.ru/nginx/download/${HTTP_MOGILEFS_MODULE_P}.tar.gz"
HTTP_MOGILEFS_MODULE_WD="${WORKDIR}/${HTTP_MOGILEFS_MODULE_P}"

inherit eutils ssl-cert toolchain-funcs perl-module ruby-ng flag-o-matic user systemd pax-utils multilib

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="
	http://sysoev.ru/nginx/
	"
SRC_URI="
	http://nginx.org/download/${P}.tar.gz -> ${P}.tar.gz
	nginx_modules_http_pagespeed? (
		${HTTP_PAGESPEED_MODULE_URI} -> ${HTTP_PAGESPEED_MODULE_P}.tar.gz
		${HTTP_PAGESPEED_PSOL_URI} -> ${HTTP_PAGESPEED_PSOL_P}.tar.gz
	)
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_hls_audio? ( ${HTTP_HLS_AUDIO_MODULE_URI} -> ${HTTP_HLS_AUDIO_MODULE_P}.tar.gz )
	nginx_modules_http_encrypted_session? ( ${HTTP_ENCRYPTED_SESSION_MODULE_URI} -> ${HTTP_ENCRYPTED_SESSION_MODULE_P}.tar.gz )
	nginx_modules_http_push_stream? ( ${HTTP_PUSH_STREAM_MODULE_URI} -> ${HTTP_PUSH_STREAM_MODULE_P}.tar.gz )
	nginx_modules_http_ctpp? ( ${HTTP_CTPP_MODULE_URI} -> ${HTTP_CTPP_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} -> ${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( ${HTTP_EY_BALANCER_MODULE_URI} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_ndk? ( ${HTTP_NDK_MODULE_URI} -> ${HTTP_NDK_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_lua_upstream? ( ${HTTP_LUA_UPSTREAM_MODULE_URI} -> ${HTTP_LUA_UPSTREAM_MODULE_P}.tar.gz )
	nginx_modules_http_replace_filter? ( ${HTTP_REPLACE_FILTER_MODULE_URI} -> ${HTTP_REPLACE_FILTER_MODULE_P}.tar.gz )
	nginx_modules_http_drizzle? ( ${HTTP_DRIZZLE_MODULE_URI} -> ${HTTP_DRIZZLE_MODULE_P}.tar.gz )
	nginx_modules_http_form_input? ( ${HTTP_FORM_INPUT_MODULE_URI} -> ${HTTP_FORM_INPUT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( ${HTTP_ECHO_MODULE_URI} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_rds_json? ( ${HTTP_RDS_JSON_MODULE_URI} -> ${HTTP_RDS_JSON_MODULE_P}.tar.gz )
	nginx_modules_http_rds_csv? ( ${HTTP_RDS_CSV_MODULE_URI} -> ${HTTP_RDS_CSV_MODULE_P}.tar.gz )
	nginx_modules_http_srcache? ( ${HTTP_SRCACHE_MODULE_URI} -> ${HTTP_SRCACHE_MODULE_P}.tar.gz )
	nginx_modules_http_set_misc? ( ${HTTP_SET_MISC_MODULE_URI} -> ${HTTP_SET_MISC_MODULE_P}.tar.gz )
	nginx_modules_http_xss? ( ${HTTP_XSS_MODULE_URI} -> ${HTTP_XSS_MODULE_P}.tar.gz )
	nginx_modules_http_array_var? ( ${HTTP_ARRAY_VAR_MODULE_URI} -> ${HTTP_ARRAY_VAR_MODULE_P}.tar.gz )
	nginx_modules_http_iconv? ( ${HTTP_ICONV_MODULE_URI} -> ${HTTP_ICONV_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( ${HTTP_MEMC_MODULE_URI} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_postgres? ( ${HTTP_POSTGRES_MODULE_URI} -> ${HTTP_POSTGRES_MODULE_P}.tar.gz )
	nginx_modules_http_coolkit? ( ${HTTP_COOLKIT_MODULE_URI} -> ${HTTP_COOLKIT_MODULE_P}.tar.gz )
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
	nginx_modules_http_supervisord? ( ${HTTP_SUPERVISORD_MODULE_URI} -> ${HTTP_SUPERVISORD_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} -> ${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	nginx_modules_http_fancyindex? ( ${HTTP_FANCYINDEX_MODULE_URI} -> ${HTTP_FANCYINDEX_MODULE_P}.tar.gz )
	nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
	nginx_modules_http_naxsi? ( ${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz )
	nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_security? ( ${HTTP_SECURITY_MODULE_URI} -> ${HTTP_SECURITY_MODULE_P}.tar.gz )
	nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? ( ${HTTP_PASSENGER_MODULE_URI} -> ${HTTP_PASSENGER_MODULE_P}.tar.gz )
	rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
	rrd? ( ${RRD_MODULE_URI} -> ${RRD_MODULE_P}.tar.gz )
	nginx_modules_http_sticky? ( ${HTTP_STICKY_MODULE_URI} -> ${HTTP_STICKY_MODULE_P}.tar.gz )
	nginx_modules_http_ajp? ( ${HTTP_AJP_MODULE_URI} -> ${HTTP_AJP_MODULE_P}.tar.gz )
	nginx_modules_http_mogilefs? ( ${HTTP_MOGILEFS_MODULE_URI} -> ${HTTP_MOGILEFS_MODULE_P}.tar.gz )
"
LICENSE="
	BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
	nginx_modules_http_security? ( Apache-2.0 )
	nginx_modules_http_push_stream? ( GPL-3 )
	nginx_modules_http_hls_audio? ( GPL-3 )
	nginx_modules_http_auth_pam? ( as-is )
"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~mipsel ~armel"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif fastcgi
geo gzip limit_conn limit_req map memcached proxy referer rewrite scgi
split_clients ssi upstream_hash upstream_ip_hash upstream_least_conn upstream_keepalive userid uwsgi"

NGINX_MODULES_OPT="addition auth_request dav degradation flv geoip gunzip gzip_static
image_filter mp4 perl random_index realip secure_link spdy stub_status sub xslt"

NGINX_MODULES_MAIL="imap pop3 smtp"

NGINX_MODULES_3RD="
	http_cache_purge
	http_headers_more
	http_encrypted_session
	http_pagespeed
	http_push_stream
	http_ey_balancer
	http_slowfs_cache
	http_ndk
	http_lua
	http_lua_upstream
	http_replace_filter
	http_form_input
	http_echo
	http_memc
	http_drizzle
	http_rds_json
	http_rds_csv
	http_postgres
	http_coolkit
	http_set_misc
	http_srcache
	http_supervisord
	http_array_var
	http_xss
	http_iconv
	http_upload_progress
	http_ctpp
	http_fancyindex
	http_upstream_check
	http_metrics
	http_naxsi
	http_dav_ext
	http_passenger
	http_security
	http_auth_pam
	http_hls_audio
	http_sticky
	http_ajp
	http_mogilefs
"

REQUIRED_USE="
		nginx_modules_http_lua? ( nginx_modules_http_ndk nginx_modules_http_rewrite )
		nginx_modules_http_lua_upstream? ( nginx_modules_http_lua )
		nginx_modules_http_rds_json? ( || ( nginx_modules_http_drizzle nginx_modules_http_postgres ) )
		nginx_modules_http_rds_csv?  ( || ( nginx_modules_http_drizzle nginx_modules_http_postgres ) )
		nginx_modules_http_form_input? ( nginx_modules_http_ndk )
		nginx_modules_http_set_misc? ( nginx_modules_http_ndk )
		nginx_modules_http_iconv? ( nginx_modules_http_ndk )
		nginx_modules_http_spdy? ( ssl )
		nginx_modules_http_encrypted_session? ( nginx_modules_http_ndk ssl )
		nginx_modules_http_array_var? ( nginx_modules_http_ndk )
		nginx_modules_http_naxsi? ( pcre )
		nginx_modules_http_pagespeed? ( pcre )
		nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
		nginx_modules_http_hls_audio? ( nginx_modules_http_lua )
		nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
		nginx_modules_http_security? ( pcre )
		nginx_modules_http_push_stream? ( ssl )
		pcre-jit? ( pcre )
"

IUSE="aio debug +http +http-cache ipv6 libatomic pam +pcre pcre-jit perftools rrd ssl vim-syntax +luajit selinux rtmp"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

CDEPEND="
	pam? ( virtual/pam )
	pcre? ( >=dev-libs/libpcre-4.2 )
	pcre-jit? ( >=dev-libs/libpcre-8.20[jit] )
	selinux? ( sec-policy/selinux-nginx )
	ssl? ( dev-libs/openssl )
	http-cache? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_ctpp? ( www-apps/ctpp2 >=sys-devel/gcc-4.6 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_drizzle? ( dev-db/drizzle )
	nginx_modules_http_lua? ( luajit? ( dev-lang/luajit:2 ) !luajit? ( >=dev-lang/lua-5 ) )
	nginx_modules_http_replace_filter? ( dev-libs/sregex )
	nginx_modules_http_metrics? ( dev-libs/yajl )
	nginx_modules_http_dav_ext? ( dev-libs/expat )
	nginx_modules_http_hls_audio? ( >=media-video/ffmpeg-2 )
	nginx_modules_http_security? (
		>=dev-libs/libxml2-2.7.8
		dev-libs/apr-util
	)
	perftools? ( dev-util/google-perftools )
	rrd? ( >=net-analyzer/rrdtool-1.3.8[graph] )

	nginx_modules_http_passenger? (
		|| (
			$(ruby_implementation_depend ruby19)
			$(ruby_implementation_depend ruby20)
			$(ruby_implementation_depend ruby21)
			$(ruby_implementation_depend ruby22)
			$(ruby_implementation_depend jruby)
		)
		>=dev-ruby/rake-0.8.1
		!!www-apache/passenger
	)
"

#	nginx_modules_http_pagespeed? ( dev-libs/psol )
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )
	nginx_modules_http_security? (
		www-servers/apache
	)
"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

S="${WORKDIR}/${P}"

pkg_setup() {
	NGINX_HOME="/var/lib/${PN}"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${HTTPD_GROUP:-$PN}
	enewuser ${HTTPD_USER:-$PN} -1 -1 "${NGINX_HOME}" ${HTTPD_GROUP:-$PN}
	eend ${?}

	if use libatomic && ! use arm; then
		ewarn ""
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if you use"
		ewarn "a different compiler or GCC <4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn ""
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is *not supported*!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use nginx_modules_http_passenger; then
		ruby-ng_pkg_setup
		use debug && append-flags -DPASSENGER_DEBUG
	fi

	if use !http; then
		ewarn ""
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-perl-install-path.patch"

	use nginx_modules_http_upstream_check && epatch "${FILESDIR}"/upstream-check-1.7.2.patch

	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):'

	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die

	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# Increasing error string (to have possibility to get all modules in nginx -V output)
	sed -i -e "s|\(NGX_MAX_ERROR_STR\)   2048|\1 4096|" "${S}"/src/core/ngx_log.h

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done

	if use nginx_modules_http_ey_balancer; then
		epatch "${FILESDIR}"/nginx-1.x-ey-balancer.patch
	fi

	if use nginx_modules_http_passenger; then
		cd ../"${HTTP_PASSENGER_MODULE_P}";

#		epatch "${FILESDIR}"/passenger-gentoo.patch
#		epatch "${FILESDIR}"/passenger-ldflags.patch
		epatch "${FILESDIR}"/passenger5-gentoo.patch
		epatch "${FILESDIR}"/passenger5-ldflags.patch
		epatch "${FILESDIR}"/passenger-contenthandler.patch

		sed \
			-e "s:/buildout/agents:/agents:" \
			-i ext/common/ResourceLocator.h

		sed \
			-e '/passenger-install-apache2-module/d' \
			-e "/passenger-install-nginx-module/d" \
			-i lib/phusion_passenger/packaging.rb || die

		rm -f bin/passenger-install-apache2-module bin/passenger-install-nginx-module || die "Unable to remove unneeded install script."
		cd "${S}"
	fi

	if use nginx_modules_http_pagespeed; then
		# Sorry. I tired in tries to patch it's buildsystem to just get psol from parentdir and don't fail the build...
		ln -s "${HTTP_PAGESPEED_PSOL_WD}" "${HTTP_PAGESPEED_MODULE_WD}/" || die "Failed to make symlink to psol"
		local arch=${ARCH};
		use x86 && arch=x86_32;
		use amd64 && arch=x86_64;
		sed -r \
			-e "s/(uname_arch)=.*/\1=${arch}/" \
			-i "${HTTP_PAGESPEED_MODULE_WD}/config";
	fi

	epatch_user

	if use nginx_modules_http_passenger; then
		cd "${HTTP_PASSENGER_MODULE_WD}";
		_ruby_each_implementation passenger_premake
	fi
}

src_configure() {
	cd "${S}"
	local myconf= http_enabled= mail_enabled=

	use aio		&& myconf+=" --with-file-aio --with-aio_module"
	use debug	&& myconf+=" --with-debug"
	use ipv6	&& myconf+=" --with-ipv6"
	use libatomic	&& myconf+=" --with-libatomic"
	use pcre	&& myconf+=" --with-pcre"
	use pcre-jit	&& myconf+=" --with-pcre-jit"

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=" --without-http_${mod}_module"
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf+=" --with-http_${mod}_module"
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=" --with-http_realip_module"
	fi

	# third-party modules
	# WARNING!!! Modules (that checked with "(**)" comment) adding order IS IMPORTANT!
# (**) http_ndk
	if use nginx_modules_http_ndk; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_NDK_MODULE_WD}"
	fi

# (**) http_set_misc
	if use nginx_modules_http_set_misc; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SET_MISC_MODULE_WD}"
	fi

# (**) http_echo
	if use nginx_modules_http_echo; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_ECHO_MODULE_WD}"
	fi

# (**) http_memc
	if use nginx_modules_http_memc; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_MEMC_MODULE_WD}"
	fi
# (**) http_lua
	if use nginx_modules_http_lua; then
		http_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$(pkg-config --variable libdir luajit)
			export LUAJIT_INC=$(pkg-config --variable includedir luajit)
		else
			export LUA_LIB=$(pkg-config --variable libdir lua)
			export LUA_INC=$(pkg-config --variable includedir lua)
		fi
		myconf+=" --add-module=${HTTP_LUA_MODULE_WD}"
	fi

# (**) http_lua_upstream
	if use nginx_modules_http_lua_upstream; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_LUA_UPSTREAM_MODULE_WD}"
	fi

# (**) http_replace_filter
	if use nginx_modules_http_replace_filter; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_REPLACE_FILTER_MODULE_WD}"
	fi

# (**) http_encrypted_session
	if use nginx_modules_http_encrypted_session; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_ENCRYPTED_SESSION_MODULE_WD}"
	fi

# (**) http_headers_more
	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_HEADERS_MORE_MODULE_WD}"
	fi

# (**) http_srcache
	if use nginx_modules_http_srcache; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SRCACHE_MODULE_WD}"
	fi

# (**) http_drizzle
	if use nginx_modules_http_drizzle; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_DRIZZLE_MODULE_WD}"
	fi

# (**) http_rds_json
	if use nginx_modules_http_rds_json; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_RDS_JSON_MODULE_WD}"
	fi

# (**) http_rds_csv
	if use nginx_modules_http_rds_csv; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_RDS_CSV_MODULE_WD}"
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_POSTGRES_MODULE_WD}"
	fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_COOLKIT_MODULE_WD}"
	fi

# http_pagespeed
	if use nginx_modules_http_pagespeed; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_PAGESPEED_MODULE_WD}"
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_PASSENGER_MODULE_WD}"
	fi

# http_push_stream
	if use nginx_modules_http_push_stream; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_PUSH_STREAM_MODULE_WD}"
	fi

# http_ctpp
	if use nginx_modules_http_ctpp; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_CTPP_MODULE_WD}"
	fi

# http_supervisord
	if use nginx_modules_http_supervisord; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SUPERVISORD_MODULE_WD}"
	fi

# http_xss
	if use nginx_modules_http_xss; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_XSS_MODULE_WD}"
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_ARRAY_VAR_MODULE_WD}"
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_FORM_INPUT_MODULE_WD}"
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_ICONV_MODULE_WD}"
	fi

# http_fancyindex
	if use nginx_modules_http_fancyindex; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_FANCYINDEX_MODULE_WD}"
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_UPLOAD_PROGRESS_MODULE_WD}"
	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_CACHE_PURGE_MODULE_WD}"
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_EY_BALANCER_MODULE_WD}"
	fi
# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SLOWFS_CACHE_MODULE_WD}"
	fi

	if use nginx_modules_http_upstream_check; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_UPSTREAM_CHECK_MODULE_WD}"
	fi

	if use nginx_modules_http_metrics; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_METRICS_MODULE_WD}"
	fi

	if use nginx_modules_http_naxsi; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_NAXSI_MODULE_WD}"
	fi

	if use nginx_modules_http_dav_ext; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_DAV_EXT_MODULE_WD}"
	fi

	if use nginx_modules_http_hls_audio; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_HLS_AUDIO_MODULE_WD}"
	fi

	if use nginx_modules_http_auth_pam; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_AUTH_PAM_MODULE_WD}"
	fi

	if use nginx_modules_http_security ; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SECURITY_MODULE_WD}/nginx/modsecurity"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi

	if use rtmp ; then
		http_enabled=1
		myconf+=" --add-module=${RTMP_MODULE_WD}"
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=" --without-http-cache"
		use ssl	&& myconf+=" --with-http_ssl_module"
	else
		myconf+=" --without-http --without-http-cache"
	fi

	use perftools	&& myconf+=" --with-google_perftools_module"
	use rrd		&& myconf+=" --add-module=${RRD_MODULE_WD}"

	if use nginx_modules_http_sticky ; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_STICKY_MODULE_WD}"
	fi

	if use nginx_modules_http_mogilefs ; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_MOGILEFS_MODULE_WD}"
	fi

	if use nginx_modules_http_ajp ; then
		http_enabled=1
		# Disabled, because of incompatibiity with 1.7.9. Will be fixed on next bump.
		#myconf+=" --add-module=${HTTP_AJP_MODULE_WD}"
		ewarn "Sorry, AJP module is currently disabled, because of it's"
		ewarn "incompatibility with ${P}"
	fi

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf+=" --without-mail_${mod}_module"
		fi
	done

	if [ $mail_enabled ]; then
		myconf+=" --with-mail"
		use ssl && myconf+=" --with-mail_ssl_module"
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=" --add-module=${mod}"
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

	if ! use prefix; then
		myconf+=" --user=${HTTPD_USER:-$PN} --group=${HTTPD_GROUP:-$PN}"
	fi

	if use nginx_modules_http_security; then
		cd "${HTTP_SECURITY_MODULE_WD}"
		./autogen.sh
		econf \
			--enable-standalone-module \
			--enable-extentions \
			--enable-request-early \
			--disable-apache2-module \
			--disable-errors \
			$(use_enable pcre-jit) \
			$(use_enable pcre-jit pcre-study) \
			$(use_enable nginx_modules_http_lua lua-cache) || die "configure failed for mod_security"
		cd "${S}"
	fi

	./configure \
		--prefix="${EPREFIX}/usr" \
		--conf-path="${EPREFIX}/etc/${PN}/${PN}.conf" \
		--error-log-path="${EPREFIX}/var/log/${PN}/error.log" \
		--pid-path="${EPREFIX}/run/${PN}.pid" \
		--lock-path="${EPREFIX}/run/lock/${PN}.lock" \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}/var/log/${PN}/access.log" \
		--http-client-body-temp-path="${EPREFIX}${NGINX_HOME_TMP}/client" \
		--http-proxy-temp-path="${EPREFIX}${NGINX_HOME_TMP}/proxy" \
		--http-fastcgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}/fastcgi" \
		--http-scgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}/scgi" \
		--http-uwsgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}/uwsgi" \
		${myconf} || die "configure failed"


		sed -i -e "s|${WORKDIR}|ext|g" objs/ngx_auto_config.h || die
}

src_compile() {
	cd "${S}"
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	use nginx_modules_http_security && emake -C "${HTTP_SECURITY_MODULE_WD}"
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}


passenger_premake() {
	# dirty spike to make passenger compilation each-ruby compatible
	mkdir -p "${S}"
	cp -r "${HTTP_PASSENGER_MODULE_P}" "${S}"
	cp -r "${PN}-${PV}" "${S}"
	cd "${S}"/"${HTTP_PASSENGER_MODULE_P}"
	sed -e "s%#{PlatformInfo.ruby_command}%${RUBY}%g" -i build/ruby_extension.rb
	sed -e "s%#{PlatformInfo.ruby_command}%${RUBY}%g" -i lib/phusion_passenger/native_support.rb
	# workaround on QA issues on passenger
	export CFLAGS="${CFLAGS} -fno-strict-aliasing -Wno-unused-result"
	export CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing -Wno-unused-result"
	rake nginx || die "Passenger premake for ${RUBY} failed!"
}

passenger_install() {
	# dirty spike to make passenger installation each-ruby compatible
	cd "${S}"/"${HTTP_PASSENGER_MODULE_P}/ext/nginx"
	rake fakeroot \
		NATIVE_PACKAGING_METHOD=ebuild \
		FS_PREFIX="${PREFIX}/usr" \
		FS_DATADIR="${PREFIX}/usr/libexec" \
		FS_DOCDIR="${PREFIX}/usr/share/doc/${P}" \
		FS_LIBDIR="${PREFIX}/usr/$(get_libdir)" \
		RUBYLIBDIR="$(ruby_rbconfig_value 'archdir')" \
		RUBYARCHDIR="$(ruby_rbconfig_value 'archdir')" \
	|| die "Passenger installation for ${RUBY} failed!"
}

src_install() {
	cd "${S}"
	emake DESTDIR="${D}" install

	host-is-pax && pax-mark m "${ED}usr/sbin/${PN}"

	cp "${FILESDIR}"/nginx.conf "${ED}"/etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	doman man/nginx.8
	dodoc CHANGES* README

	keepdir /var/www/localhost

	rm -rf "${ED}"/usr/html || die

	# set up a list of directories to keep
	local keepdir_list="${NGINX_HOME_TMP}/client"
	local module
	for module in proxy fastcgi scgi uwsgi; do
		use nginx_modules_http_${module} && keepdir_list+=" ${NGINX_HOME_TMP}/${module}"
	done

	keepdir "/var/log/${PN}" ${keepdir_list}

	# this solves a problem with SELinux where nginx doesn't see the directories
	# as root and tries to create them as nginx
	fperms 0750 "${NGINX_HOME_TMP}"
	fowners "${HTTPD_USER:-${PN}}:0" "${NGINX_HOME_TMP}"

	fperms 0700 "/var/log/${PN}" ${keepdir_list}
	fowners "${HTTPD_USER:-${PN}}:${HTTPD_GROUP:-${PN}}" "/var/log/${PN}" ${keepdir_list}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate nginx


# http_perl
	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		perl_delete_localpod
		cd "${S}"
	fi

# http_push_stream
	if use nginx_modules_http_push_stream; then
		docinto "${HTTP_PUSH_STREAM_MODULE_P}"
		dodoc "${HTTP_PUSH_STREAM_MODULE_WD}"/{CHANGELOG.textile,README.textile}
	fi

# http_ctpp
	if use nginx_modules_http_ctpp; then
		docinto "${HTTP_CTPP_MODULE_P}"
		dodoc "${HTTP_CTPP_MODULE_WD}"/{CHANGELOG-ru,README}
	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		docinto "${HTTP_CACHE_PURGE_MODULE_P}"
		dodoc "${HTTP_CACHE_PURGE_MODULE_WD}"/{CHANGES,README.md}
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		docinto "${HTTP_UPLOAD_PROGRESS_MODULE_P}"
		dodoc "${HTTP_UPLOAD_PROGRESS_MODULE_WD}"/README
	fi

# http_fancyindex
	if use nginx_modules_http_fancyindex; then
		docinto "${HTTP_FANCYINDEX_MODULE_P}"
		dodoc "${HTTP_FANCYINDEX_MODULE_WD}"/{README.md,HACKING.rst}
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		docinto "${HTTP_EY_BALANCER_MODULE_P}"
		dodoc "${HTTP_EY_BALANCER_MODULE_WD}"/README
	fi

# http_ndk
	if use nginx_modules_http_ndk; then
		docinto "${HTTP_NDK_MODULE_P}"
		dodoc "${HTTP_NDK_MODULE_WD}"/README
	fi

# http_headers_more
	if use nginx_modules_http_headers_more; then
		docinto "${HTTP_HEADERS_MORE_MODULE_P}"
		dodoc "${HTTP_HEADERS_MORE_MODULE_WD}"/README.markdown
	fi

# http_encrypted_session
	if use nginx_modules_http_encrypted_session; then
		docinto "${HTTP_ENCRYPTED_SESSION_MODULE_P}"
		dodoc "${HTTP_ENCRYPTED_SESSION_MODULE_WD}"/README
	fi

# http_lua
	if use nginx_modules_http_lua; then
		docinto "${HTTP_LUA_MODULE_P}"
		dodoc "${HTTP_LUA_MODULE_WD}"/{Changes,README.markdown}
	fi

# http_lua_upstream
	if use nginx_modules_http_lua_upstream; then
		docinto "${HTTP_LUA_UPSTREAM_MODULE_P}"
		dodoc "${HTTP_LUA_UPSTREAM_MODULE_WD}"/README.md
	fi

# http_lua
	if use nginx_modules_http_replace_filter; then
		docinto "${HTTP_REPLACE_FILTER_MODULE_P}"
		dodoc "${HTTP_REPLACE_FILTER_MODULE_WD}"/README.markdown
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		docinto "${HTTP_FORM_INPUT_MODULE_P}"
		dodoc "${HTTP_FORM_INPUT_MODULE_WD}"/README
	fi

# http_echo
	if use nginx_modules_http_echo; then
		docinto "${HTTP_ECHO_MODULE_P}"
		dodoc "${HTTP_ECHO_MODULE_WD}"/README.markdown
	fi

# http_srcache
	if use nginx_modules_http_srcache; then
		docinto "${HTTP_SRCACHE_MODULE_P}"
		dodoc "${HTTP_SRCACHE_MODULE_WD}"/README.markdown
	fi

# http_memc
	if use nginx_modules_http_memc; then
		docinto "${HTTP_MEMC_MODULE_P}"
		dodoc "${HTTP_MEMC_MODULE_WD}"/README.markdown
	fi

# http_drizzle
	if use nginx_modules_http_drizzle; then
		docinto "${HTTP_DRIZZLE_MODULE_P}"
		dodoc "${HTTP_DRIZZLE_MODULE_WD}"/README
	fi

# http_rds_json
	if use nginx_modules_http_rds_json; then
		docinto "${HTTP_RDS_JSON_MODULE_P}"
		dodoc "${HTTP_RDS_JSON_MODULE_WD}"/README
	fi

# http_rds_csv
	if use nginx_modules_http_rds_csv; then
		docinto "${HTTP_RDS_CSV_MODULE_P}"
		dodoc "${HTTP_RDS_CSV_MODULE_WD}"/README
	fi

# http_postgres
	if use nginx_modules_http_postgres; then
		docinto "${HTTP_POSTGRES_MODULE_P}"
		dodoc "${HTTP_POSTGRES_MODULE_WD}"/README.md
	fi

# http_coolkit
	if use nginx_modules_http_coolkit; then
		docinto "${HTTP_COOLKIT_MODULE_P}"
		dodoc "${HTTP_COOLKIT_MODULE_WD}"/README
	fi

# http_set_misc
	if use nginx_modules_http_set_misc; then
		docinto "${HTTP_SET_MISC_MODULE_P}"
		dodoc "${HTTP_SET_MISC_MODULE_WD}"/README.markdown
	fi

# http_xss
	if use nginx_modules_http_xss; then
		docinto "${HTTP_XSS_MODULE_P}"
		dodoc "${HTTP_XSS_MODULE_WD}"/README
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		docinto "${HTTP_ARRAY_VAR_MODULE_P}"
		dodoc "${HTTP_ARRAY_VAR_MODULE_WD}"/README
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		docinto "${HTTP_ICONV_MODULE_P}"
		dodoc "${HTTP_ICONV_MODULE_WD}"/README
	fi

# http_supervisord
	if use nginx_modules_http_supervisord; then
		docinto "${HTTP_SUPERVISORD_MODULE_P}"
		dodoc "${HTTP_SUPERVISORD_MODULE_WD}"/README
	fi

# http_slowfs_cache
	if use nginx_modules_http_slowfs_cache; then
		docinto "${HTTP_SLOWFS_CACHE_MODULE_P}"
		dodoc "${HTTP_SLOWFS_CACHE_MODULE_WD}"/{CHANGES,README.md}
	fi

# http_passenger
	if use nginx_modules_http_passenger; then
		_ruby_each_implementation passenger_install
		cd "${S}"
	fi

	if use nginx_modules_http_upstream_check; then
		docinto "${HTTP_UPSTREAM_CHECK_MODULE_P}"
		dodoc "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/{README,CHANGES}
	fi

	if use nginx_modules_http_metrics; then
		docinto "${HTTP_METRICS_MODULE_P}"
		dodoc "${HTTP_METRICS_MODULE_WD}"/README.md
	fi

	if use nginx_modules_http_naxsi; then
		insinto /etc/nginx
		doins "${HTTP_NAXSI_MODULE_WD}"/../naxsi_config/naxsi_core.rules
	fi

	if use rtmp; then
		docinto "${RTMP_MODULE_P}"
		dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
	fi

	if use nginx_modules_http_dav_ext; then
		docinto "${HTTP_DAV_EXT_MODULE_P}"
		dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README
	fi

	if use nginx_modules_http_hls_audio; then
		docinto "${HTTP_HLS_AUDIO_MODULE_P}"
		dodoc "${HTTP_HLS_AUDIO_MODULE_WD}"/{README.md,nginx.conf}
	fi

	if use nginx_modules_http_pagespeed; then
		docinto "${HTTP_PAGESPEED_MODULE_P}"
		dodoc "${HTTP_PAGESPEED_MODULE_WD}"/README.md
	fi

	if use nginx_modules_http_auth_pam; then
		docinto "${HTTP_AUTH_PAM_MODULE_P}"
		dodoc "${HTTP_AUTH_PAM_MODULE_WD}"/{README,ChangeLog}
	fi

	if use nginx_modules_http_security; then
		docinto "${HTTP_SECURITY_MODULE_P}"
		dodoc "${HTTP_SECURITY_MODULE_WD}"/{CHANGES,README.TXT,authors.txt}
	fi

	if use nginx_modules_http_sticky; then
		docinto ${HTTP_STICKY_MODULE_P}
		dodoc "${HTTP_STICKY_MODULE_WD}"/{README.md,Changelog.txt,docs/sticky.pdf}
	fi

	if use nginx_modules_http_ajp; then
		docinto ${HTTP_AJP_MODULE_P}
		dodoc "${HTTP_AJP_MODULE_WD}"/README
	fi

}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${EROOT}"/etc/ssl/"${PN}"/"${PN}".key ]; then
			install_cert /etc/ssl/"${PN}"/"${PN}"
			use prefix || chown "${HTTPD_USER:-$PN}":"${HTTPD_GROUP:-$PN}" "${EROOT}"/etc/ssl/"${PN}"/"${PN}".{crt,csr,key,pem}
		fi
	fi

	if use nginx_modules_http_lua && use nginx_modules_http_spdy; then
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua spdy\". For more info, see http://git.io/OldLsg"
	fi

	if use nginx_modules_http_passenger; then
		ewarn "Please, keep notice, that 'passenger_root' directive"
		ewarn "should point to exactly location of 'locations.ini'"
		ewarn "file from this package (i.e. it should be full path)"
	fi

	# If the nginx user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c 'cd /var/log/${PN}/ && ls' "${HTTPD_USER:-$PN}" >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn "Please make sure that the nginx user (${HTTPD_USER:-$PN}) or group (${HTTPD_GROUP:-$PN}) has at least"
		ewarn "'rx' permissions on /var/log/${PN} (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi
}

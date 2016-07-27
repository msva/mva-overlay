# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# ^ ruby eclasses doesn't support EAPI6

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
USE_RUBY="jruby ruby20 ruby21 ruby22 ruby23"
RUBY_OPTIONAL="yes"
LUA_OPTIONAL="yes"

# http_enchanced_memcache_module (https://github.com/dreamcommerce/ngx_http_enhanced_memcached_module/tags, Apache-2.0)
HTTP_ENMEMCACHE_MODULE_A="dreamcommerce"
HTTP_ENMEMCACHE_MODULE_PN="ngx_http_enhanced_memcached_module"
HTTP_ENMEMCACHE_MODULE_PV="nginx_1.9.5"
HTTP_ENMEMCACHE_MODULE_P="${HTTP_ENMEMCACHE_MODULE_PN}-${HTTP_ENMEMCACHE_MODULE_SHA:-${HTTP_ENMEMCACHE_MODULE_PV}}"
HTTP_ENMEMCACHE_MODULE_URI="https://github.com/${HTTP_ENMEMCACHE_MODULE_A}/${HTTP_ENMEMCACHE_MODULE_PN}/archive/${HTTP_ENMEMCACHE_MODULE_SHA:-${HTTP_ENMEMCACHE_MODULE_PV}}.tar.gz"
HTTP_ENMEMCACHE_MODULE_WD="${WORKDIR}/${HTTP_ENMEMCACHE_MODULE_P}"

# http_tcp_proxy_module (https://github.com/dreamcommerce/nginx_tcp_proxy_module/tags, BSD-2)
HTTP_TCPPROXY_MODULE_A="dreamcommerce"
HTTP_TCPPROXY_MODULE_PN="nginx_tcp_proxy_module"
HTTP_TCPPROXY_MODULE_PV="nginx_1.11.1"
HTTP_TCPPROXY_MODULE_P="${HTTP_TCPPROXY_MODULE_PN}-${HTTP_TCPPROXY_MODULE_SHA:-${HTTP_TCPPROXY_MODULE_PV}}"
HTTP_TCPPROXY_MODULE_URI="https://github.com/${HTTP_TCPPROXY_MODULE_A}/${HTTP_TCPPROXY_MODULE_PN}/archive/${HTTP_TCPPROXY_MODULE_SHA:-${HTTP_TCPPROXY_MODULE_PV}}.tar.gz"
HTTP_TCPPROXY_MODULE_WD="${WORKDIR}/${HTTP_TCPPROXY_MODULE_P}"

# http_passenger (https://github.com/phusion/passenger/tags, MIT)
HTTP_PASSENGER_MODULE_A="phusion"
HTTP_PASSENGER_MODULE_PN="passenger"
HTTP_PASSENGER_MODULE_PV="5.0.30"
#HTTP_PASSENGER_MODULE_SHA=""
HTTP_PASSENGER_MODULE_P="${HTTP_PASSENGER_MODULE_PN}-${HTTP_PASSENGER_MODULE_SHA:-release-${HTTP_PASSENGER_MODULE_PV}}"
HTTP_PASSENGER_MODULE_URI="https://github.com/${HTTP_PASSENGER_MODULE_A}/${HTTP_PASSENGER_MODULE_PN}/archive/${HTTP_PASSENGER_MODULE_SHA:-release-${HTTP_PASSENGER_MODULE_PV}}.tar.gz"
HTTP_PASSENGER_MODULE_WD="${WORKDIR}/${HTTP_PASSENGER_MODULE_P}"

# http_passenger_union_station_hooks_core (https://github.com/phusion/union_station_hooks_core/tags, MIT)
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_A="phusion"
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PN="union_station_hooks_core"
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PV="2.1.1"
#HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_SHA=""
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_P="${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PN}-${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_SHA:-release-${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PV}}"
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_URI="https://github.com/${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_A}/${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PN}/archive/${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_SHA:-release-${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PV}}.tar.gz"
HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_WD="${WORKDIR}/${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_P}"

# http_passenger_union_station_hooks_rails (https://github.com/phusion/union_station_hooks_rails/tags, MIT)
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_A="phusion"
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PN="union_station_hooks_rails"
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PV="2.0.0"
#HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_SHA=""
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_P="${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PN}-${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_SHA:-release-${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PV}}"
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_URI="https://github.com/${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_A}/${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PN}/archive/${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_SHA:-release-${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PV}}.tar.gz"
HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_WD="${WORKDIR}/${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_P}"

# TODO: change passenger URI to: http://s3.amazonaws.com/phusion-passenger/releases/passenger-5.0.20.tar.gz

# http_pagespeed (https://github.com/pagespeed/ngx_pagespeed/tags, BSD-2)
HTTP_PAGESPEED_MODULE_A="pagespeed"
HTTP_PAGESPEED_MODULE_PN="ngx_pagespeed"
HTTP_PAGESPEED_MODULE_PV="1.11.33.2-beta"
#HTTP_PAGESPEED_MODULE_SHA="1c5b61679cc47716930399516e188e1e896060dd"
HTTP_PAGESPEED_MODULE_P="${HTTP_PAGESPEED_MODULE_PN}-${HTTP_PAGESPEED_MODULE_SHA:-${HTTP_PAGESPEED_MODULE_PV}}"
HTTP_PAGESPEED_MODULE_URI="https://github.com/${HTTP_PAGESPEED_MODULE_A}/${HTTP_PAGESPEED_MODULE_PN}/archive/${HTTP_PAGESPEED_MODULE_SHA:-v${HTTP_PAGESPEED_MODULE_PV}}.tar.gz"
HTTP_PAGESPEED_MODULE_WD="${WORKDIR}/${HTTP_PAGESPEED_MODULE_P}"

HTTP_PAGESPEED_PSOL_PN="psol"
HTTP_PAGESPEED_PSOL_PV="${HTTP_PAGESPEED_MODULE_PV/-*/}"
HTTP_PAGESPEED_PSOL_P="${HTTP_PAGESPEED_PSOL_PN}-${HTTP_PAGESPEED_PSOL_SHA:-${HTTP_PAGESPEED_PSOL_PV}}"
HTTP_PAGESPEED_PSOL_URI="https://dl.google.com/dl/page-speed/${HTTP_PAGESPEED_PSOL_PN}/${HTTP_PAGESPEED_PSOL_PV}.tar.gz"
HTTP_PAGESPEED_PSOL_WD="${WORKDIR}/${HTTP_PAGESPEED_PSOL_PN}"

# http_hls_audio (https://github.com/flavioribeiro/nginx-audio-track-for-hls-module/tags, BSD-2)
HTTP_HLS_AUDIO_MODULE_A="flavioribeiro"
HTTP_HLS_AUDIO_MODULE_PN="nginx-audio-track-for-hls-module"
HTTP_HLS_AUDIO_MODULE_PV="0.2"
HTTP_HLS_AUDIO_MODULE_SHA="84f79f70ac9752deb263d777308e9d667ae34e57"
HTTP_HLS_AUDIO_MODULE_P="${HTTP_HLS_AUDIO_MODULE_PN}-${HTTP_HLS_AUDIO_MODULE_SHA:-${HTTP_HLS_AUDIO_MODULE_PV}}"
HTTP_HLS_AUDIO_MODULE_URI="https://github.com/${HTTP_HLS_AUDIO_MODULE_A}/${HTTP_HLS_AUDIO_MODULE_PN}/archive/${HTTP_HLS_AUDIO_MODULE_SHA:-${HTTP_HLS_AUDIO_MODULE_PV}}.tar.gz"
HTTP_HLS_AUDIO_MODULE_WD="${WORKDIR}/${HTTP_HLS_AUDIO_MODULE_P}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module/tags, BSD-2)
HTTP_UPLOAD_PROGRESS_MODULE_A="masterzen"
HTTP_UPLOAD_PROGRESS_MODULE_PN="nginx-upload-progress-module"
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.1"
HTTP_UPLOAD_PROGRESS_MODULE_P="${HTTP_UPLOAD_PROGRESS_MODULE_PN}-${HTTP_UPLOAD_PROGRESS_MODULE_SHA:-${HTTP_UPLOAD_PROGRESS_MODULE_PV}}"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/${HTTP_UPLOAD_PROGRESS_MODULE_A}/${HTTP_UPLOAD_PROGRESS_MODULE_PN}/archive/${HTTP_UPLOAD_PROGRESS_MODULE_SHA:-v${HTTP_UPLOAD_PROGRESS_MODULE_PV}}.tar.gz"
HTTP_UPLOAD_PROGRESS_MODULE_WD="${WORKDIR}/${HTTP_UPLOAD_PROGRESS_MODULE_P}"

# http_nchan (https://github.com/slact/nchan/tags, BSD-2)
HTTP_NCHAN_MODULE_A="slact"
HTTP_NCHAN_MODULE_PN="nchan"
HTTP_NCHAN_MODULE_PV="0.99.16"
HTTP_NCHAN_MODULE_P="${HTTP_NCHAN_MODULE_PN}-${HTTP_NCHAN_MODULE_SHA:-${HTTP_NCHAN_MODULE_PV}}"
HTTP_NCHAN_MODULE_URI="https://github.com/${HTTP_NCHAN_MODULE_A}/${HTTP_NCHAN_MODULE_PN}/archive/${HTTP_NCHAN_MODULE_SHA:-v${HTTP_NCHAN_MODULE_PV}}.tar.gz"
HTTP_NCHAN_MODULE_WD="${WORKDIR}/${HTTP_NCHAN_MODULE_P}"

# http_headers_more (https://github.com/openresty/headers-more-nginx-module/tags, BSD)
HTTP_HEADERS_MORE_MODULE_A="openresty"
HTTP_HEADERS_MORE_MODULE_PN="headers-more-nginx-module"
HTTP_HEADERS_MORE_MODULE_PV="0.30"
#HTTP_HEADERS_MORE_MODULE_SHA="a744defdfac1d6874152a51e3a8a604a85354a2c"
HTTP_HEADERS_MORE_MODULE_P="${HTTP_HEADERS_MORE_MODULE_PN}-${HTTP_HEADERS_MORE_MODULE_SHA:-${HTTP_HEADERS_MORE_MODULE_PV}}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/${HTTP_HEADERS_MORE_MODULE_A}/${HTTP_HEADERS_MORE_MODULE_PN}/archive/${HTTP_HEADERS_MORE_MODULE_SHA:-v${HTTP_HEADERS_MORE_MODULE_PV}}.tar.gz"
HTTP_HEADERS_MORE_MODULE_WD="${WORKDIR}/${HTTP_HEADERS_MORE_MODULE_P}"

# http_encrypted_session (https://github.com/openresty/encrypted-session-nginx-module/tags, BSD)
HTTP_ENCRYPTED_SESSION_MODULE_A="openresty"
HTTP_ENCRYPTED_SESSION_MODULE_PN="encrypted-session-nginx-module"
HTTP_ENCRYPTED_SESSION_MODULE_PV="0.05"
HTTP_ENCRYPTED_SESSION_MODULE_P="${HTTP_ENCRYPTED_SESSION_MODULE_PN}-${HTTP_ENCRYPTED_SESSION_MODULE_SHA:-${HTTP_ENCRYPTED_SESSION_MODULE_PV}}"
HTTP_ENCRYPTED_SESSION_MODULE_URI="https://github.com/${HTTP_ENCRYPTED_SESSION_MODULE_A}/${HTTP_ENCRYPTED_SESSION_MODULE_PN}/archive/${HTTP_ENCRYPTED_SESSION_MODULE_SHA:-v${HTTP_ENCRYPTED_SESSION_MODULE_PV}}.tar.gz"
HTTP_ENCRYPTED_SESSION_MODULE_WD="${WORKDIR}/${HTTP_ENCRYPTED_SESSION_MODULE_P}"

# http_push_stream (https://github.com/wandenberg/nginx-push-stream-module/tags, BSD)
HTTP_PUSH_STREAM_MODULE_A="wandenberg"
HTTP_PUSH_STREAM_MODULE_PN="nginx-push-stream-module"
HTTP_PUSH_STREAM_MODULE_PV="0.5.2"
HTTP_PUSH_STREAM_MODULE_P="${HTTP_PUSH_STREAM_MODULE_PN}-${HTTP_PUSH_STREAM_MODULE_SHA:-${HTTP_PUSH_STREAM_MODULE_PV}}"
HTTP_PUSH_STREAM_MODULE_URI="https://github.com/${HTTP_PUSH_STREAM_MODULE_A}/${HTTP_PUSH_STREAM_MODULE_PN}/archive/${HTTP_PUSH_STREAM_MODULE_PV}.tar.gz"
HTTP_PUSH_STREAM_MODULE_WD="${WORKDIR}/${HTTP_PUSH_STREAM_MODULE_P}"

# http_ctpp2 (http://ngx-ctpp.vbart.ru/ (ru) http://ngx-ctpp.vbart.info/ (en), BSD)
HTTP_CTPP_MODULE_PV="0.5"
HTTP_CTPP_MODULE_P="ngx_ctpp2-${HTTP_CTPP_MODULE_PV}"
HTTP_CTPP_MODULE_URI="http://dl.vbart.ru/ngx-ctpp/${HTTP_CTPP_MODULE_P}.tar.gz"
HTTP_CTPP_MODULE_WD="${WORKDIR}/${HTTP_CTPP_MODULE_P}"

# http_cache_purge (https://github.com/FRiCKLE/ngx_cache_purge/tags, BSD-2)
HTTP_CACHE_PURGE_MODULE_A="FRiCKLE"
HTTP_CACHE_PURGE_MODULE_PN="ngx_cache_purge"
HTTP_CACHE_PURGE_MODULE_PV="2.3"
HTTP_CACHE_PURGE_MODULE_P="${HTTP_CACHE_PURGE_MODULE_PN}-${HTTP_CACHE_PURGE_MODULE_SHA:-${HTTP_CACHE_PURGE_MODULE_PV}}"
HTTP_CACHE_PURGE_MODULE_URI="https://github.com/${HTTP_CACHE_PURGE_MODULE_A}/${HTTP_CACHE_PURGE_MODULE_PN}/archive/${HTTP_CACHE_PURGE_MODULE_PV}.tar.gz"
HTTP_CACHE_PURGE_MODULE_WD="${WORKDIR}/${HTTP_CACHE_PURGE_MODULE_P}"

# http_ey-balancer/maxconn module (https://github.com/msva/nginx-ey-balancer/tags, MIT)
HTTP_EY_BALANCER_MODULE_A="msva"
HTTP_EY_BALANCER_MODULE_PN="nginx-ey-balancer"
HTTP_EY_BALANCER_MODULE_PV="0.0.9"
HTTP_EY_BALANCER_MODULE_P="${HTTP_EY_BALANCER_MODULE_PN}-${HTTP_EY_BALANCER_MODULE_SHA:-${HTTP_EY_BALANCER_MODULE_PV}}"
HTTP_EY_BALANCER_MODULE_URI="https://github.com/${HTTP_EY_BALANCER_MODULE_A}/${HTTP_EY_BALANCER_MODULE_PN}/archive/${HTTP_EY_BALANCER_MODULE_SHA:-v${HTTP_EY_BALANCER_MODULE_PV}}.tar.gz"
HTTP_EY_BALANCER_MODULE_WD="${WORKDIR}/${HTTP_EY_BALANCER_MODULE_P}"

# http_ndk, NginX DevKit module (https://github.com/simpl/ngx_devel_kit/tags, BSD)
HTTP_NDK_MODULE_A="simpl"
HTTP_NDK_MODULE_PN="ngx_devel_kit"
HTTP_NDK_MODULE_PV="0.3.0"
HTTP_NDK_MODULE_P="${HTTP_NDK_MODULE_PN}-${HTTP_NDK_MODULE_SHA:-${HTTP_NDK_MODULE_PV}}"
HTTP_NDK_MODULE_URI="https://github.com/${HTTP_NDK_MODULE_A}/${HTTP_NDK_MODULE_PN}/archive/${HTTP_NDK_MODULE_SHA:-v${HTTP_NDK_MODULE_PV}}.tar.gz"
HTTP_NDK_MODULE_WD="${WORKDIR}/${HTTP_NDK_MODULE_P}"

# http_redis, NginX Redis 2.0 module (https://github.com/openresty/redis2-nginx-module/tags, BSD)
HTTP_REDIS_MODULE_A="openresty"
HTTP_REDIS_MODULE_PN="redis2-nginx-module"
HTTP_REDIS_MODULE_PV="0.13"
#HTTP_REDIS_MODULE_SHA=""
HTTP_REDIS_MODULE_P="${HTTP_REDIS_MODULE_PN}-${HTTP_REDIS_MODULE_SHA:-${HTTP_REDIS_MODULE_PV}}"
HTTP_REDIS_MODULE_URI="https://github.com/${HTTP_REDIS_MODULE_A}/${HTTP_REDIS_MODULE_PN}/archive/${HTTP_REDIS_MODULE_SHA:-v${HTTP_REDIS_MODULE_PV}}.tar.gz"
HTTP_REDIS_MODULE_WD="${WORKDIR}/${HTTP_REDIS_MODULE_P}"

# http_lua, NginX Lua module (https://github.com/openresty/lua-nginx-module/tags, BSD)
HTTP_LUA_MODULE_A="openresty"
HTTP_LUA_MODULE_PN="lua-nginx-module"
HTTP_LUA_MODULE_PV="0.10.6rc1"
#HTTP_LUA_MODULE_SHA="d44f8e04db2f6e3d08b9ac6a8aac863c1bd603e8"
HTTP_LUA_MODULE_P="${HTTP_LUA_MODULE_PN}-${HTTP_LUA_MODULE_SHA:-${HTTP_LUA_MODULE_PV}}"
HTTP_LUA_MODULE_URI="https://github.com/${HTTP_LUA_MODULE_A}/${HTTP_LUA_MODULE_PN}/archive/${HTTP_LUA_MODULE_SHA:-v${HTTP_LUA_MODULE_PV}}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/${HTTP_LUA_MODULE_P}"

# stream_lua, NginX Lua module (https://github.com/openresty/stream-lua-nginx-module/tags, BSD)
STREAM_LUA_MODULE_A="openresty"
STREAM_LUA_MODULE_PN="stream-lua-nginx-module"
STREAM_LUA_MODULE_PV="0.0.2"
STREAM_LUA_MODULE_SHA="6ed0a0e52064e482af7eb9c40b1bdb3ba4d0d922"
STREAM_LUA_MODULE_P="${STREAM_LUA_MODULE_PN}-${STREAM_LUA_MODULE_SHA:-${STREAM_LUA_MODULE_PV}}"
STREAM_LUA_MODULE_URI="https://github.com/${STREAM_LUA_MODULE_A}/${STREAM_LUA_MODULE_PN}/archive/${STREAM_LUA_MODULE_SHA:-v${STREAM_LUA_MODULE_PV}}.tar.gz"
STREAM_LUA_MODULE_WD="${WORKDIR}/${STREAM_LUA_MODULE_P}"

# http_drizzle NginX Drizzle module (https://github.com/openresty/drizzle-nginx-module/tags, BSD)
HTTP_DRIZZLE_MODULE_A="openresty"
HTTP_DRIZZLE_MODULE_PN="drizzle-nginx-module"
HTTP_DRIZZLE_MODULE_PV="0.1.9"
HTTP_DRIZZLE_MODULE_SHA="e37b98d8e5b5eef008a5e77b73343ce2d1aa8df2"
HTTP_DRIZZLE_MODULE_P="${HTTP_DRIZZLE_MODULE_PN}-${HTTP_DRIZZLE_MODULE_SHA:-${HTTP_DRIZZLE_MODULE_PV}}"
HTTP_DRIZZLE_MODULE_URI="https://github.com/${HTTP_DRIZZLE_MODULE_A}/${HTTP_DRIZZLE_MODULE_PN}/archive/${HTTP_DRIZZLE_MODULE_SHA:-v${HTTP_DRIZZLE_MODULE_PV}}.tar.gz"
HTTP_DRIZZLE_MODULE_WD="${WORKDIR}/${HTTP_DRIZZLE_MODULE_P}"

# NginX form-input module (https://github.com/calio/form-input-nginx-module/tags, BSD)
HTTP_FORM_INPUT_MODULE_A="calio"
HTTP_FORM_INPUT_MODULE_PN="form-input-nginx-module"
HTTP_FORM_INPUT_MODULE_PV="0.12"
HTTP_FORM_INPUT_MODULE_P="${HTTP_FORM_INPUT_MODULE_PN}-${HTTP_FORM_INPUT_MODULE_SHA:-${HTTP_FORM_INPUT_MODULE_PV}}"
HTTP_FORM_INPUT_MODULE_URI="https://github.com/${HTTP_FORM_INPUT_MODULE_A}/${HTTP_FORM_INPUT_MODULE_PN}/archive/${HTTP_FORM_INPUT_MODULE_SHA:-v${HTTP_FORM_INPUT_MODULE_PV}}.tar.gz"
HTTP_FORM_INPUT_MODULE_WD="${WORKDIR}/${HTTP_FORM_INPUT_MODULE_P}"

# NginX echo module (https://github.com/openresty/echo-nginx-module/tags, BSD)
HTTP_ECHO_MODULE_A="openresty"
HTTP_ECHO_MODULE_PN="echo-nginx-module"
HTTP_ECHO_MODULE_PV="0.59"
HTTP_ECHO_MODULE_P="${HTTP_ECHO_MODULE_PN}-${HTTP_ECHO_MODULE_SHA:-${HTTP_ECHO_MODULE_PV}}"
HTTP_ECHO_MODULE_URI="https://github.com/${HTTP_ECHO_MODULE_A}/${HTTP_ECHO_MODULE_PN}/archive/${HTTP_ECHO_MODULE_SHA:-v${HTTP_ECHO_MODULE_PV}}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/${HTTP_ECHO_MODULE_P}"

# NginX Featured mecached module (https://github.com/openresty/memc-nginx-module/tags, BSD)
HTTP_MEMC_MODULE_A="openresty"
HTTP_MEMC_MODULE_PN="memc-nginx-module"
HTTP_MEMC_MODULE_PV="0.17"
HTTP_MEMC_MODULE_P="${HTTP_MEMC_MODULE_PN}-${HTTP_MEMC_MODULE_SHA:-${HTTP_MEMC_MODULE_PV}}"
HTTP_MEMC_MODULE_URI="https://github.com/${HTTP_MEMC_MODULE_A}/${HTTP_MEMC_MODULE_PN}/archive/${HTTP_MEMC_MODULE_SHA:-v${HTTP_MEMC_MODULE_PV}}.tar.gz"
HTTP_MEMC_MODULE_WD="${WORKDIR}/${HTTP_MEMC_MODULE_P}"

# NginX RDS-JSON module (https://github.com/openresty/rds-json-nginx-module/tags, BSD)
HTTP_RDS_JSON_MODULE_A="openresty"
HTTP_RDS_JSON_MODULE_PN="rds-json-nginx-module"
HTTP_RDS_JSON_MODULE_PV="0.14"
HTTP_RDS_JSON_MODULE_P="${HTTP_RDS_JSON_MODULE_PN}-${HTTP_RDS_JSON_MODULE_SHA:-${HTTP_RDS_JSON_MODULE_PV}}"
HTTP_RDS_JSON_MODULE_URI="https://github.com/${HTTP_RDS_JSON_MODULE_A}/${HTTP_RDS_JSON_MODULE_PN}/archive/${HTTP_RDS_JSON_MODULE_SHA:-v${HTTP_RDS_JSON_MODULE_PV}}.tar.gz"
HTTP_RDS_JSON_MODULE_WD="${WORKDIR}/${HTTP_RDS_JSON_MODULE_P}"

# NginX RDS-CSV module (https://github.com/openresty/rds-csv-nginx-module/tags, BSD)
HTTP_RDS_CSV_MODULE_A="openresty"
HTTP_RDS_CSV_MODULE_PN="rds-csv-nginx-module"
HTTP_RDS_CSV_MODULE_PV="0.07"
HTTP_RDS_CSV_MODULE_P="${HTTP_RDS_CSV_MODULE_PN}-${HTTP_RDS_CSV_MODULE_SHA:-${HTTP_RDS_CSV_MODULE_PV}}"
HTTP_RDS_CSV_MODULE_URI="https://github.com/${HTTP_RDS_CSV_MODULE_A}/${HTTP_RDS_CSV_MODULE_PN}/archive/${HTTP_RDS_CSV_MODULE_SHA:-v${HTTP_RDS_CSV_MODULE_PV}}.tar.gz"
HTTP_RDS_CSV_MODULE_WD="${WORKDIR}/${HTTP_RDS_CSV_MODULE_P}"

# NginX SRCache module (https://github.com/openresty/srcache-nginx-module/tags, BSD)
HTTP_SRCACHE_MODULE_A="openresty"
HTTP_SRCACHE_MODULE_PN="srcache-nginx-module"
HTTP_SRCACHE_MODULE_PV="0.31"
HTTP_SRCACHE_MODULE_P="${HTTP_SRCACHE_MODULE_PN}-${HTTP_SRCACHE_MODULE_SHA:-${HTTP_SRCACHE_MODULE_PV}}"
HTTP_SRCACHE_MODULE_URI="https://github.com/${HTTP_SRCACHE_MODULE_A}/${HTTP_SRCACHE_MODULE_PN}/archive/${HTTP_SRCACHE_MODULE_SHA:-v${HTTP_SRCACHE_MODULE_PV}}.tar.gz"
HTTP_SRCACHE_MODULE_WD="${WORKDIR}/${HTTP_SRCACHE_MODULE_P}"

# NginX Set-Misc module (https://github.com/openresty/set-misc-nginx-module/tags, BSD)
HTTP_SET_MISC_MODULE_A="openresty"
HTTP_SET_MISC_MODULE_PN="set-misc-nginx-module"
HTTP_SET_MISC_MODULE_PV="0.30"
HTTP_SET_MISC_MODULE_P="${HTTP_SET_MISC_MODULE_PN}-${HTTP_SET_MISC_MODULE_SHA:-${HTTP_SET_MISC_MODULE_PV}}"
HTTP_SET_MISC_MODULE_URI="https://github.com/${HTTP_SET_MISC_MODULE_A}/${HTTP_SET_MISC_MODULE_PN}/archive/${HTTP_SET_MISC_MODULE_SHA:-v${HTTP_SET_MISC_MODULE_PV}}.tar.gz"
HTTP_SET_MISC_MODULE_WD="${WORKDIR}/${HTTP_SET_MISC_MODULE_P}"

# NginX XSS module (https://github.com/openresty/xss-nginx-module/tags, BSD)
HTTP_XSS_MODULE_A="openresty"
HTTP_XSS_MODULE_PN="xss-nginx-module"
HTTP_XSS_MODULE_PV="0.05"
HTTP_XSS_MODULE_P="${HTTP_XSS_MODULE_PN}-${HTTP_XSS_MODULE_SHA:-${HTTP_XSS_MODULE_PV}}"
HTTP_XSS_MODULE_URI="https://github.com/${HTTP_XSS_MODULE_A}/${HTTP_XSS_MODULE_PN}/archive/${HTTP_XSS_MODULE_SHA:-v${HTTP_XSS_MODULE_PV}}.tar.gz"
HTTP_XSS_MODULE_WD="${WORKDIR}/${HTTP_XSS_MODULE_P}"

# NginX Array-Var module (https://github.com/openresty/array-var-nginx-module/tags, BSD)
HTTP_ARRAY_VAR_MODULE_A="openresty"
HTTP_ARRAY_VAR_MODULE_PN="array-var-nginx-module"
HTTP_ARRAY_VAR_MODULE_PV="0.05"
HTTP_ARRAY_VAR_MODULE_P="${HTTP_ARRAY_VAR_MODULE_PN}-${HTTP_ARRAY_VAR_MODULE_SHA:-${HTTP_ARRAY_VAR_MODULE_PV}}"
HTTP_ARRAY_VAR_MODULE_URI="https://github.com/${HTTP_ARRAY_VAR_MODULE_A}/${HTTP_ARRAY_VAR_MODULE_PN}/archive/${HTTP_ARRAY_VAR_MODULE_SHA:-v${HTTP_ARRAY_VAR_MODULE_PV}}.tar.gz"
HTTP_ARRAY_VAR_MODULE_WD="${WORKDIR}/${HTTP_ARRAY_VAR_MODULE_P}"

# NginX Lua-Upstream module (https://github.com/openresty/lua-upstream-nginx-module/tags, BSD)
HTTP_LUA_UPSTREAM_MODULE_A="openresty"
HTTP_LUA_UPSTREAM_MODULE_PN="lua-upstream-nginx-module"
HTTP_LUA_UPSTREAM_MODULE_PV="0.05"
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
HTTP_ICONV_MODULE_PV="0.14"
HTTP_ICONV_MODULE_P="${HTTP_ICONV_MODULE_PN}-${HTTP_ICONV_MODULE_SHA:-${HTTP_ICONV_MODULE_PV}}"
HTTP_ICONV_MODULE_URI="https://github.com/${HTTP_ICONV_MODULE_A}/${HTTP_ICONV_MODULE_PN}/archive/${HTTP_ICONV_MODULE_SHA:-v${HTTP_ICONV_MODULE_PV}}.tar.gz"
HTTP_ICONV_MODULE_WD="${WORKDIR}/${HTTP_ICONV_MODULE_P}"

# NginX postgres module (https://github.com/FRiCKLE/ngx_postgres/tags, BSD-2)
HTTP_POSTGRES_MODULE_A="FRiCKLE"
HTTP_POSTGRES_MODULE_PN="ngx_postgres"
HTTP_POSTGRES_MODULE_PV="1.0rc7"
#HTTP_POSTGRES_MODULE_SHA="7950a250e9bc99967d83c57fbbadb9d0d6d5c4bf"
HTTP_POSTGRES_MODULE_P="${HTTP_POSTGRES_MODULE_PN}-${HTTP_POSTGRES_MODULE_SHA:-${HTTP_POSTGRES_MODULE_PV}}"
HTTP_POSTGRES_MODULE_URI="https://github.com/${HTTP_POSTGRES_MODULE_A}/${HTTP_POSTGRES_MODULE_PN}/archive/${HTTP_POSTGRES_MODULE_SHA:-${HTTP_POSTGRES_MODULE_PV}}.tar.gz"
HTTP_POSTGRES_MODULE_WD="${WORKDIR}/${HTTP_POSTGRES_MODULE_P}"

# NginX coolkit module (https://github.com/FRiCKLE/ngx_coolkit/tags, BSD-2)
HTTP_COOLKIT_MODULE_A="FRiCKLE"
HTTP_COOLKIT_MODULE_PN="ngx_coolkit"
HTTP_COOLKIT_MODULE_PV="0.2rc3"
HTTP_COOLKIT_MODULE_P="${HTTP_COOLKIT_MODULE_PN}-${HTTP_COOLKIT_MODULE_SHA:-${HTTP_COOLKIT_MODULE_PV}}"
HTTP_COOLKIT_MODULE_URI="https://github.com/${HTTP_COOLKIT_MODULE_A}/${HTTP_COOLKIT_MODULE_PN}/archive/${HTTP_COOLKIT_MODULE_SHA:-${HTTP_COOLKIT_MODULE_PV}}.tar.gz"
HTTP_COOLKIT_MODULE_WD="${WORKDIR}/${HTTP_COOLKIT_MODULE_P}"

# NginX Supervisord module (http://labs.frickle.com/nginx_ngx_supervisord/, BSD-2)
HTTP_SUPERVISORD_MODULE_PV="1.4"
HTTP_SUPERVISORD_MODULE_P="ngx_supervisord-${HTTP_SUPERVISORD_MODULE_PV}"
HTTP_SUPERVISORD_MODULE_URI="http://labs.frickle.com/files/${HTTP_SUPERVISORD_MODULE_P}.tar.gz"
HTTP_SUPERVISORD_MODULE_WD="${WORKDIR}/${HTTP_SUPERVISORD_MODULE_P}"

# http_slowfs_cache (https://github.com/FRiCKLE/ngx_slowfs_cache/tags, BSD-2)
HTTP_SLOWFS_CACHE_MODULE_A="FRiCKLE"
HTTP_SLOWFS_CACHE_MODULE_PN="ngx_slowfs_cache"
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="${HTTP_SLOWFS_CACHE_MODULE_PN}-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="https://github.com/${HTTP_SLOWFS_CACHE_MODULE_A}/${HTTP_SLOWFS_CACHE_MODULE_PN}/archive/${HTTP_SLOWFS_CACHE_MODULE_SHA:-${HTTP_SLOWFS_CACHE_MODULE_PV}}.tar.gz"
HTTP_SLOWFS_CACHE_MODULE_WD="${WORKDIR}/${HTTP_SLOWFS_CACHE_MODULE_P}"

# http_fancyindex (https://github.com/aperezdc/ngx-fancyindex/tags , BSD)
HTTP_FANCYINDEX_MODULE_A="aperezdc"
HTTP_FANCYINDEX_MODULE_PN="ngx-fancyindex"
HTTP_FANCYINDEX_MODULE_PV="0.4.0"
#HTTP_FANCYINDEX_MODULE_SHA="ba8b4ece63da157f5eec4df3d8fdc9108b05b3eb"
HTTP_FANCYINDEX_MODULE_P="${HTTP_FANCYINDEX_MODULE_PN}-${HTTP_FANCYINDEX_MODULE_SHA:-${HTTP_FANCYINDEX_MODULE_PV}}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/${HTTP_FANCYINDEX_MODULE_A}/${HTTP_FANCYINDEX_MODULE_PN}/archive/${HTTP_FANCYINDEX_MODULE_SHA:-v${HTTP_FANCYINDEX_MODULE_PV}}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/${HTTP_FANCYINDEX_MODULE_P}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module/tags, BSD)
HTTP_UPSTREAM_CHECK_MODULE_A="yaoweibin"
HTTP_UPSTREAM_CHECK_MODULE_PN="nginx_upstream_check_module"
#HTTP_UPSTREAM_CHECK_MODULE_PV="0.3.0"
HTTP_UPSTREAM_CHECK_MODULE_SHA="10782eaff51872a8f44e65eed89bbe286004bcb1"
HTTP_UPSTREAM_CHECK_MODULE_P="${HTTP_UPSTREAM_CHECK_MODULE_PN}-${HTTP_UPSTREAM_CHECK_MODULE_SHA:-${HTTP_UPSTREAM_CHECK_MODULE_PV}}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/${HTTP_UPSTREAM_CHECK_MODULE_A}/${HTTP_UPSTREAM_CHECK_MODULE_PN}/archive/${HTTP_UPSTREAM_CHECK_MODULE_SHA:-v${HTTP_UPSTREAM_CHECK_MODULE_PV}}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/${HTTP_UPSTREAM_CHECK_MODULE_P}"

# http_metrics (https://github.com/zenops/ngx_metrics/tags, BSD)
HTTP_METRICS_MODULE_A="zenops"
HTTP_METRICS_MODULE_PN="ngx_metrics"
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="${HTTP_METRICS_MODULE_PN}-${HTTP_METRICS_MODULE_SHA:-${HTTP_METRICS_MODULE_PV}}"
HTTP_METRICS_MODULE_URI="https://github.com/${HTTP_METRICS_MODULE_A}/${HTTP_METRICS_MODULE_PN}/archive/${HTTP_METRICS_MODULE_SHA:-v${HTTP_METRICS_MODULE_PV}}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/${HTTP_METRICS_MODULE_P}"

# naxsi-core (https://github.com/nbs-system/naxsi/tags, GPLv2+)
HTTP_NAXSI_MODULE_A="nbs-system"
HTTP_NAXSI_MODULE_PN="naxsi"
HTTP_NAXSI_MODULE_PV="0.55rc2"
#HTTP_NAXSI_MODULE_SHA="bf6c9cba178225d5ff5cf3de2ebda9b0a2f06a66"
HTTP_NAXSI_MODULE_P="${HTTP_NAXSI_MODULE_PN}-${HTTP_NAXSI_MODULE_SHA:-${HTTP_NAXSI_MODULE_PV}}"
HTTP_NAXSI_MODULE_URI="https://github.com/${HTTP_NAXSI_MODULE_A}/${HTTP_NAXSI_MODULE_PN}/archive/${HTTP_NAXSI_MODULE_SHA:-${HTTP_NAXSI_MODULE_PV}}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/${HTTP_NAXSI_MODULE_P}/naxsi_src"

# nginx-dav-ext-module (https://github.com/arut/nginx-dav-ext-module/tags, BSD)
HTTP_DAV_EXT_MODULE_A="arut"
HTTP_DAV_EXT_MODULE_PN="nginx-dav-ext-module"
HTTP_DAV_EXT_MODULE_PV="0.0.3"
HTTP_DAV_EXT_MODULE_P="${HTTP_DAV_EXT_MODULE_PN}-${HTTP_DAV_EXT_MODULE_SHA:-${HTTP_DAV_EXT_MODULE_PV}}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/${HTTP_DAV_EXT_MODULE_A}/${HTTP_DAV_EXT_MODULE_PN}/archive/${HTTP_DAV_EXT_MODULE_SHA:-v${HTTP_DAV_EXT_MODULE_PV}}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/${HTTP_DAV_EXT_MODULE_P}"

# Broken with 1.11
## nginx-rtmp-module (https://github.com/arut/nginx-rtmp-module/tags, BSD)
#RTMP_MODULE_A="arut"
#RTMP_MODULE_PN="nginx-rtmp-module"
#RTMP_MODULE_PV="1.1.7"
##RTMP_MODULE_SHA="e08959247dc840bb42cdf3389b1f5edb5686825f"
#RTMP_MODULE_P="${RTMP_MODULE_PN}-${RTMP_MODULE_SHA:-${RTMP_MODULE_PV}}"
#RTMP_MODULE_URI="https://github.com/${RTMP_MODULE_A}/${RTMP_MODULE_PN}/archive/${RTMP_MODULE_SHA:-v${RTMP_MODULE_PV}}.tar.gz"
#RTMP_MODULE_WD="${WORKDIR}/${RTMP_MODULE_P}"

# mod_security for nginx (https://github.com/SpiderLabs/ModSecurity/tags, Apache-2.0)
HTTP_SECURITY_MODULE_A="SpiderLabs"
HTTP_SECURITY_MODULE_PN="ModSecurity"
HTTP_SECURITY_MODULE_PV="2.9.1"
HTTP_SECURITY_MODULE_SHA="923c3c67938da4de4f7f147816b6d2d6ffff5e6f"
HTTP_SECURITY_MODULE_P="${HTTP_SECURITY_MODULE_PN}-${HTTP_SECURITY_MODULE_SHA:-${HTTP_SECURITY_MODULE_PV}}"
HTTP_SECURITY_MODULE_URI="https://github.com/${HTTP_SECURITY_MODULE_A}/${HTTP_SECURITY_MODULE_PN}/archive/${HTTP_SECURITY_MODULE_SHA:-v${HTTP_SECURITY_MODULE_PV}}.tar.gz"
HTTP_SECURITY_MODULE_WD="${WORKDIR}/${HTTP_SECURITY_MODULE_P}"

# http_auth_pam (https://github.com/stogh/ngx_http_auth_pam_module/tags, BSD-2)
HTTP_AUTH_PAM_MODULE_A="stogh"
HTTP_AUTH_PAM_MODULE_PN="ngx_http_auth_pam_module"
HTTP_AUTH_PAM_MODULE_PV="1.5.1"
HTTP_AUTH_PAM_MODULE_P="${HTTP_AUTH_PAM_MODULE_PN}-${HTTP_AUTH_PAM_MODULE_SHA:-${HTTP_AUTH_PAM_MODULE_PV}}"
HTTP_AUTH_PAM_MODULE_URI="https://github.com/${HTTP_AUTH_PAM_MODULE_A}/${HTTP_AUTH_PAM_MODULE_PN}/archive/v${HTTP_AUTH_PAM_MODULE_SHA:-${HTTP_AUTH_PAM_MODULE_PV}}.tar.gz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/${HTTP_AUTH_PAM_MODULE_P}"

# http_rrd (https://github.com/evanmiller/mod_rrd_graph/tags, BSD-2)
RRD_MODULE_A="evanmiller"
RRD_MODULE_PN="mod_rrd_graph"
RRD_MODULE_PV="0.2.0"
RRD_MODULE_SHA="9b749a2d4b8ae47c313054b5a23b982e9a285c54"
RRD_MODULE_P="${RRD_MODULE_PN}-${RRD_MODULE_SHA:-${RRD_MODULE_PV}}"
RRD_MODULE_URI="https://github.com/${RRD_MODULE_A}/${RRD_MODULE_PN}/archive/${RRD_MODULE_SHA:-${RRD_MODULE_PV}}.tar.gz"
RRD_MODULE_WD="${WORKDIR}/${RRD_MODULE_P}"

# sticky-module (https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/downloads#tag-downloads, BSD-2)
HTTP_STICKY_MODULE_A="nginx-goodies"
HTTP_STICKY_MODULE_PN="nginx-sticky-module-ng"
HTTP_STICKY_MODULE_PV="1.2.6"
HTTP_STICKY_MODULE_PV_SHA="c78b7dd79d0d"
HTTP_STICKY_MODULE_P="${HTTP_STICKY_MODULE_PN}-${HTTP_STICKY_MODULE_PV}"
HTTP_STICKY_MODULE_URI="https://bitbucket.org/${HTTP_STICKY_MODULE_A}/${HTTP_STICKY_MODULE_PN}/get/${HTTP_STICKY_MODULE_PV}.tar.gz"
HTTP_STICKY_MODULE_WD="${WORKDIR}/${HTTP_STICKY_MODULE_A}-${HTTP_STICKY_MODULE_PN}-${HTTP_STICKY_MODULE_PV_SHA}"

# ajp-module (https://github.com/yaoweibin/nginx_ajp_module/tags, BSD-2)
HTTP_AJP_MODULE_A="yaoweibin"
HTTP_AJP_MODULE_PN="nginx_ajp_module"
HTTP_AJP_MODULE_PV="0.3.0"
HTTP_AJP_MODULE_SHA="bf6cd93f2098b59260de8d494f0f4b1f11a84627"
HTTP_AJP_MODULE_P="${HTTP_AJP_MODULE_PN}-${HTTP_AJP_MODULE_SHA:-${HTTP_AJP_MODULE_PV}}"
HTTP_AJP_MODULE_URI="https://github.com/yaoweibin/nginx_ajp_module/archive/${HTTP_AJP_MODULE_SHA:-v${HTTP_AJP_MODULE_PV}}.tar.gz"
HTTP_AJP_MODULE_WD="${WORKDIR}/${HTTP_AJP_MODULE_P}"

# mogilefs-module (http://www.grid.net.ru/nginx/mogilefs.en.html, BSD-2)
HTTP_MOGILEFS_MODULE_A="vkholodkov"
HTTP_MOGILEFS_MODULE_PN="nginx-mogilefs-module"
HTTP_MOGILEFS_MODULE_PV="1.0.4"
HTTP_MOGILEFS_MODULE_SHA="020937ff4624fc31928adb51a5c43753bf256b34"
HTTP_MOGILEFS_MODULE_P="${HTTP_MOGILEFS_MODULE_PN}-${HTTP_MOGILEFS_MODULE_SHA:-${HTTP_MOGILEFS_MODULE_PV}}"
HTTP_MOGILEFS_MODULE_URI="https://github.com/${HTTP_MOGILEFS_MODULE_A}/${HTTP_MOGILEFS_MODULE_PN}/archive/${HTTP_MOGILEFS_MODULE_SHA:-${HTTP_MOGILEFS_MODULE_PV}}.tar.gz"
HTTP_MOGILEFS_MODULE_WD="${WORKDIR}/${HTTP_MOGILEFS_MODULE_P}"

# NJS-module (http://hg.nginx.org/njs/, BSD-2)
HTTP_NJS_MODULE_PN="njs"
HTTP_NJS_MODULE_SHA="1c50334fbea6"
HTTP_NJS_MODULE_P="${HTTP_NJS_MODULE_PN}-${HTTP_NJS_MODULE_SHA:-${HTTP_NJS_MODULE_PV}}"
HTTP_NJS_MODULE_URI="http://hg.nginx.org/${HTTP_NJS_MODULE_PN}/archive/${HTTP_NJS_MODULE_SHA}.tar.gz"
HTTP_NJS_MODULE_WD="${WORKDIR}/${HTTP_NJS_MODULE_P}"

# nginx-ldap-auth-module (https://github.com/kvspb/nginx-auth-ldap, BSD-2)
HTTP_LDAP_MODULE_A="kvspb"
HTTP_LDAP_MODULE_PN="nginx-auth-ldap"
#HTTP_LDAP_MODULE_PV=""
HTTP_LDAP_MODULE_SHA="dbcef31bebb2d54b6120422d0b178bbf78bc48f7"
HTTP_LDAP_MODULE_P="${HTTP_LDAP_MODULE_PN}-${HTTP_LDAP_MODULE_SHA-:${HTTP_LDAP_MODULE_PV}}"
HTTP_LDAP_MODULE_URI="https://github.com/kvspb/nginx-auth-ldap/archive/${HTTP_LDAP_MODULE_SHA-:${HTTP_LDAP_MODULE_PV}}.tar.gz"
HTTP_LDAP_MODULE_WD="${WORKDIR}/${HTTP_LDAP_MODULE_P}"

SSL_DEPS_SKIP=1

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
	nginx_modules_http_enmemcache? ( ${HTTP_ENMEMCACHE_MODULE_URI} -> ${HTTP_ENMEMCACHE_MODULE_P}.tar.gz )
	nginx_modules_http_tcpproxy? ( ${HTTP_TCPPROXY_MODULE_URI} -> ${HTTP_TCPPROXY_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_hls_audio? ( ${HTTP_HLS_AUDIO_MODULE_URI} -> ${HTTP_HLS_AUDIO_MODULE_P}.tar.gz )
	nginx_modules_http_encrypted_session? ( ${HTTP_ENCRYPTED_SESSION_MODULE_URI} -> ${HTTP_ENCRYPTED_SESSION_MODULE_P}.tar.gz )
	nginx_modules_http_push_stream? ( ${HTTP_PUSH_STREAM_MODULE_URI} -> ${HTTP_PUSH_STREAM_MODULE_P}.tar.gz )
	nginx_modules_http_ctpp? ( ${HTTP_CTPP_MODULE_URI} -> ${HTTP_CTPP_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} -> ${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( ${HTTP_EY_BALANCER_MODULE_URI} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_ndk? ( ${HTTP_NDK_MODULE_URI} -> ${HTTP_NDK_MODULE_P}.tar.gz )
	nginx_modules_http_redis? ( ${HTTP_REDIS_MODULE_URI} -> ${HTTP_REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_stream_lua? ( ${STREAM_LUA_MODULE_URI} -> ${STREAM_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_lua_upstream? ( ${HTTP_LUA_UPSTREAM_MODULE_URI} -> ${HTTP_LUA_UPSTREAM_MODULE_P}.tar.gz )
	nginx_modules_http_replace_filter? ( ${HTTP_REPLACE_FILTER_MODULE_URI} -> ${HTTP_REPLACE_FILTER_MODULE_P}.tar.gz )
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
	nginx_modules_http_nchan? ( ${HTTP_NCHAN_MODULE_URI} -> ${HTTP_NCHAN_MODULE_P}.tar.gz )
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_supervisord? ( ${HTTP_SUPERVISORD_MODULE_URI} -> ${HTTP_SUPERVISORD_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} -> ${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	nginx_modules_http_fancyindex? ( ${HTTP_FANCYINDEX_MODULE_URI} -> ${HTTP_FANCYINDEX_MODULE_P}.tar.gz )
	nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
	nginx_modules_http_naxsi? ( ${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz )
	nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_security? ( ${HTTP_SECURITY_MODULE_URI} -> ${HTTP_SECURITY_MODULE_P}.tar.gz )
	nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
	nginx_modules_http_passenger? (
		${HTTP_PASSENGER_MODULE_URI} -> ${HTTP_PASSENGER_MODULE_P}.tar.gz
		${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_URI} -> ${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_P}.tar.gz
		${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_URI} -> ${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_P}.tar.gz
	)
	rrd? ( ${RRD_MODULE_URI} -> ${RRD_MODULE_P}.tar.gz )
	nginx_modules_http_sticky? ( ${HTTP_STICKY_MODULE_URI} -> ${HTTP_STICKY_MODULE_P}.tar.gz )
	nginx_modules_http_ajp? ( ${HTTP_AJP_MODULE_URI} -> ${HTTP_AJP_MODULE_P}.tar.gz )
	nginx_modules_http_mogilefs? ( ${HTTP_MOGILEFS_MODULE_URI} -> ${HTTP_MOGILEFS_MODULE_P}.tar.gz )
	nginx_modules_http_njs? ( ${HTTP_NJS_MODULE_URI} -> ${HTTP_NJS_MODULE_P}.tar.gz )
	nginx_modules_http_drizzle? ( ${HTTP_DRIZZLE_MODULE_URI} -> ${HTTP_DRIZZLE_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
	nginx_modules_http_auth_ldap? ( ${HTTP_LDAP_MODULE_URI} -> ${HTTP_LDAP_MODULE_P}.tar.gz )
"
#rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
LICENSE="
	BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
	nginx_modules_http_security? ( Apache-2.0 )
	nginx_modules_http_enmemcache? ( Apache-2.0 )
	nginx_modules_http_security? ( Apache-2.0 )
	nginx_modules_http_push_stream? ( GPL-3 )
	nginx_modules_http_hls_audio? ( GPL-3 )
"
SLOT="mainline"
KEYWORDS="~amd64 ~x86 ~arm"

NGINX_MODULES_STD="
	access
	auth_basic
	autoindex
	browser
	charset
	empty_gif
	fastcgi
	geo
	gzip
	limit_conn
	limit_req
	map
	memcached
	proxy
	referer
	rewrite
	scgi
	split_clients
	ssi
	upstream_hash
	upstream_ip_hash
	upstream_keepalive
	upstream_least_conn
	upstream_zone
	userid
	uwsgi
"
NGINX_MODULES_STREAM="
	access
	geo
	geoip
	limit_conn
	map
	return
	split_clients
	upstream_hash
	upstream_least_conn
	upstream_zone
"

NGINX_MODULES_HTTP_OPT="
	addition
	auth_request
	dav
	degradation
	flv
	geoip
	gunzip
	gzip_static
	image_filter
	mp4
	perl
	random_index
	realip
	secure_link
	slice
	stub_status
	sub
	xslt
	v2
"

NGINX_MODULES_MAIL="
	imap
	pop3
	smtp
"

NGINX_MODULES_3RD="
	http_enmemcache
	http_tcpproxy
	http_cache_purge
	http_headers_more
	http_encrypted_session
	http_pagespeed
	http_push_stream
	http_ey_balancer
	http_slowfs_cache
	http_ndk
	http_redis
	http_lua
	stream_lua
	http_lua_upstream
	http_replace_filter
	http_form_input
	http_echo
	http_memc
	http_nchan
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
	http_njs
	http_drizzle
	http_upstream_check
	http_auth_ldap
"

NGINX_MODULES_DYN="
	geoip
	image_filter
	xslt
"

REQUIRED_USE="
		luajit? ( nginx_modules_http_lua )
		nginx_modules_http_v2? ( ssl )
		nginx_modules_stream_lua? ( ssl )
		nginx_modules_http_lua? ( nginx_modules_http_ndk nginx_modules_http_rewrite )
		nginx_modules_http_lua_upstream? ( nginx_modules_http_lua )
		nginx_modules_http_rds_json? ( nginx_modules_http_postgres )
		nginx_modules_http_rds_csv?  ( nginx_modules_http_postgres )
		nginx_modules_http_form_input? ( nginx_modules_http_ndk )
		nginx_modules_http_set_misc? ( nginx_modules_http_ndk )
		nginx_modules_http_iconv? ( nginx_modules_http_ndk )
		nginx_modules_http_encrypted_session? ( nginx_modules_http_ndk ssl )
		nginx_modules_http_array_var? ( nginx_modules_http_ndk )
		nginx_modules_http_naxsi? ( pcre )
		nginx_modules_http_pagespeed? ( pcre )
		nginx_modules_http_postgres? ( nginx_modules_http_rewrite )
		nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
		nginx_modules_http_hls_audio? ( nginx_modules_http_lua )
		nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
		nginx_modules_http_security? ( pcre )
		nginx_modules_http_push_stream? ( ssl )
		pcre-jit? ( pcre )
		http2? ( nginx_modules_http_v2 )
"

IUSE="aio debug +http +http-cache ipv6 libatomic mail pam +pcre pcre-jit perftools rrd ssl stream threads vim-syntax luajit selinux http2"
# rtmp"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_HTTP_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_STREAM; do
	IUSE="${IUSE} nginx_modules_stream_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

CDEPEND="
	pam? ( virtual/pam )
	pcre? ( >=dev-libs/libpcre-4.2 )
	pcre-jit? ( >=dev-libs/libpcre-8.20[jit] )
	selinux? ( sec-policy/selinux-nginx )
	ssl? ( dev-libs/openssl:* )
	http-cache? ( userland_GNU? ( dev-libs/openssl:* ) )
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_ctpp? ( www-apps/ctpp2 >=sys-devel/gcc-4.6:* )
	nginx_modules_http_postgres? ( dev-db/postgresql:*[threads=] )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? ( userland_GNU? ( dev-libs/openssl:* ) )
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_stream_lua? (
		|| (
			virtual/lua[luajit=]
			!luajit? (
				|| (
					( virtual/lua dev-lang/lua:5.1 )
					<dev-lang/lua-5.2:0
				)
			)
			luajit? (
				|| (
					virtual/lua[luajit]
					>=dev-lang/luajit-2
				)
			)
		)
	)
	nginx_modules_http_lua? (
		|| (
			virtual/lua[luajit=]
			!luajit? (
				|| (
					virtual/lua
					dev-lang/lua:0
				)
			)
			luajit? (
				|| (
					virtual/lua[luajit]
					>=dev-lang/luajit-2
				)
			)
		)
	)
	nginx_modules_http_replace_filter? ( dev-libs/sregex )
	nginx_modules_http_metrics? ( dev-libs/yajl )
	nginx_modules_http_nchan? ( dev-libs/hiredis )
	nginx_modules_http_dav_ext? ( dev-libs/expat )
	nginx_modules_http_hls_audio? ( >=media-video/ffmpeg-2 )
	nginx_modules_http_security? (
		>=dev-libs/libxml2-2.7.8
		dev-libs/apr-util
	)
	perftools? ( dev-util/google-perftools )
	rrd? ( >=net-analyzer/rrdtool-1.3.8[graph] )

	nginx_modules_http_passenger? (
		$(ruby_implementations_depend)
		>=dev-ruby/rake-0.8.1
		!!www-apache/passenger
		dev-libs/libev
		dev-libs/libuv
	)
	nginx_modules_http_auth_ldap? ( net-nds/openldap[ssl?] )
	nginx_modules_http_drizzle? ( dev-libs/libdrizzle )
"
# nginx_modules_http_lua? ( $(lua_implementations_depend) )
#	nginx_modules_http_pagespeed? ( dev-libs/psol )
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )
	nginx_modules_http_security? (
		www-servers/apache-headers
		dev-libs/apr
		dev-libs/apr-util
	)
"

# mod_pagespeed (precompiled psol static library, actually) issues QA warning
QA_EXECSTACK="usr/sbin/nginx"
#QA_WX_LOAD="usr/sbin/nginx"

PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

S="${WORKDIR}/${P}"

custom_econf() {
	local EXTRA_ECONF=(${EXTRA_ECONF[@]})
	local ECONF_SOURCE=${ECONF_SOURCE:-.};
	set -- "$@" "${EXTRA_ECONF[@]}"
	echo "${ECONF_SOURCE}/configure" "${@}"
	"${ECONF_SOURCE}/configure" "${@}"
}

pkg_setup() {
	NGINX_HOME="/var/lib/${PN}"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${HTTPD_GROUP:-$PN}
	enewuser ${HTTPD_USER:-$PN} -1 -1 "${NGINX_HOME}" ${HTTPD_GROUP:-$PN}
	eend ${?}

	if use nginx_modules_http_lua || use luajit; then
		einfo ""
		einfo "You will probably want to add 'lua' overlay"
		einfo "and emerge @openresty set (only after adding lua repo)"
		einfo "This is needed because I moved all lua-related packages there"
		einfo "(to avoid double maintenance work here and there)."
		einfo ""
	fi

	if use libatomic && ! use arm; then
		ewarn ""
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if you use"
		ewarn "a different compiler or GCC <4.1"
		ewarn ""
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn ""
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is *not supported*!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
		ewarn ""
	fi

	if use nginx_modules_http_passenger; then
		use debug && append-flags -DPASSENGER_DEBUG
### QA
		append-cflags "-fno-strict-aliasing -Wno-unused-result -Wno-unused-variable"
		append-cxxflags "-fno-strict-aliasing -Wno-unused-result -Wno-unused-variable"
### /QA
		ruby-ng_pkg_setup
	fi

	if use nginx_modules_http_hls_audio; then
### QA
		append-cflags "-Wno-deprecated-declarations"
### /QA
	fi

	if use !http; then
		ewarn ""
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
		ewarn ""
	fi

	if use nginx_modules_http_mogilefs; then
		die "MogileFS module is currently broken and unmaintained by upstream"
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	PORTAGE_QUIET=1 default
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-perl-install-path.patch"

# Don't support 1.9 atm
#	use nginx_modules_http_upstream_check && (
#		epatch "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/check_1.7.5+.patch
## no releases
##		use nginx_modules_http_upstream_fair && epatch "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/upstream_fair.patch
#		use nginx_modules_http_sticky && (
#			cd "${HTTP_STICKY_MODULE_WD}"
#			epatch "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/nginx-sticky-module.patch
#		)
#	)

	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):'

	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die

	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# Increasing error string (to have possibility to get all modules in nginx -V output)
	sed -i -e "/^#define NGX_MAX_ERROR_STR/s|\(NGX_MAX_ERROR_STR\).*|\1 ${NGINX_MAX_ERROR_LENGTH:-4096}|" "${S}"/src/core/ngx_log.h

	# Increasing maximum dyn modules amount
	sed -i -e "/^#define NGX_MAX_DYNAMIC_MODULES/s|\(NGX_MAX_DYNAMIC_MODULES\).*|\1 ${NGINX_MAX_DYNAMIC_MODULES:-256}|" "${S}"/src/core/ngx_module.c

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done

	if use luajit && use nginx_modules_http_lua; then
		sed -r \
			-e "s|-lluajit-5.1|$($(tc-getPKG_CONFIG) --libs luajit)|g" \
			-i "${STREAM_LUA_MODULE_WD}/config"
	fi

	if use luajit && use nginx_modules_http_lua; then
		sed -r \
			-e "s|-lluajit-5.1|$($(tc-getPKG_CONFIG) --libs luajit)|g" \
			-i "${HTTP_LUA_MODULE_WD}/config"
	fi

	if use nginx_modules_http_ey_balancer; then
		epatch "${FILESDIR}"/nginx-1.x-ey-balancer.patch
	fi

	if use nginx_modules_http_passenger; then
		pushd "${HTTP_PASSENGER_MODULE_WD}" &>/dev/null

		epatch "${FILESDIR}"/passenger5-gentoo.patch
		epatch "${FILESDIR}"/passenger5-ldflags.patch
		epatch "${FILESDIR}"/passenger5-isnan.patch
		epatch "${FILESDIR}"/passenger-contenthandler.patch

		sed -r \
			-e "s:/buildout(/support-binaries):\1:" \
			-i src/cxx_supportlib/ResourceLocator.h

		sed \
			-e '/passenger-install-apache2-module/d' \
			-e "/passenger-install-nginx-module/d" \
			-i src/ruby_supportlib/phusion_passenger/packaging.rb

		sed -r \
			-e 's#(LIBEV_CFLAGS =).*#\1 "-I/usr/include"#' \
			-e 's#(LIBUV_CFLAGS =).*#\1 "-I/usr/include"#' \
			-i build/common_library.rb

		sed \
			-e 's#local/include#include#' \
			-i src/ruby_supportlib/phusion_passenger/platform_info/cxx_portability.rb

############################################################
## WARNING! That piece is trying to unpatch passenger from it's bundled libev
## May provide crashes at runtime! If it is a case why you're looking here
## then report that issue, please.
##
## Also you can participate here: http://git.io/vL2In
############################################################
		sed \
			-e '/ev_loop_get_pipe/d' \
			-e '/ev_backend_fd/d' \
			-i src/cxx_supportlib/SafeLibev.h src/cxx_supportlib/BackgroundEventLoop.cpp
############################################################

		rm  -r \
			bin/passenger-install-apache2-module \
			bin/passenger-install-nginx-module \
			src/apache2_module \
			src/cxx_supportlib/vendor-copy/libuv \
			src/cxx_supportlib/vendor-modified/libev

		cp -rl "${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_WD}"/* "${HTTP_PASSENGER_MODULE_WD}/src/ruby_supportlib/phusion_passenger/vendor/${HTTP_PASSENGER_UNION_STATION_HOOKS_CORE_PN}" || die "Failed to insert union_station_hooks_core"
		cp -rl "${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_WD}"/* "${HTTP_PASSENGER_MODULE_WD}/src/ruby_supportlib/phusion_passenger/vendor/${HTTP_PASSENGER_UNION_STATION_HOOKS_RAILS_PN}" || die "Failed to insert union_station_hooks_rails"

		popd &>/dev/null
	fi

	if use nginx_modules_http_pagespeed; then
		# TODO: replace precompiled psol with that one, built from apache module?
		cp -rl "${HTTP_PAGESPEED_PSOL_WD}" "${HTTP_PAGESPEED_MODULE_WD}/" || die "Failed to insert psol"
		local arch=${ARCH};
		use x86 && arch=x86_32;
		use amd64 && arch=x86_64;
		sed -r \
			-e "s/(uname_arch)=.*/\1=${arch}/" \
			-i "${HTTP_PAGESPEED_MODULE_WD}/config";
	fi

	if use nginx_modules_http_upload_progress; then
		pushd "${HTTP_UPLOAD_PROGRESS_MODULE_WD}" &>/dev/null
		epatch "${FILESDIR}"/upload_put.patch
		popd &>/dev/null
	fi

	if use nginx_modules_http_cache_purge; then
		pushd "${HTTP_CACHE_PURGE_MODULE_WD}" &>/dev/null
		epatch "${FILESDIR}"/cache_purge_dyn.patch
		popd &>/dev/null
	fi

	if use nginx_modules_http_ajp; then
		pushd "${HTTP_AJP_MODULE_WD}" &>/dev/null
		epatch "${FILESDIR}"/ajp_issue37.patch
		epatch "${FILESDIR}"/ajp_dyn.patch
		popd &>/dev/null
	fi

	if use nginx_modules_http_tcpproxy; then
		epatch "${HTTP_TCPPROXY_MODULE_WD}"/tcp.patch
	fi

	if use nginx_modules_http_nchan; then
		pushd "${HTTP_NCHAN_MODULE_WD}" &>/dev/null
		sed -r \
			-e '2,22d;23ingx_feature_libs="-lhiredis"' \
			-i config
		popd &>/dev/null
	fi

	epatch_user
}

src_configure() {
	local myconf= http_enabled= mail_enabled=

	use aio			&& myconf+=" --with-file-aio"
	use debug		&& myconf+=" --with-debug"
	use ipv6		&& myconf+=" --with-ipv6"
	use libatomic	&& myconf+=" --with-libatomic"
	use pcre		&& myconf+=" --with-pcre"
	use pcre-jit	&& myconf+=" --with-pcre-jit"
	use threads		&& myconf+=" --with-threads"

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=" --without-http_${mod}_module"
		fi
	done

	for mod in $NGINX_MODULES_HTTP_OPT; do
#		local dyn=
#		for dm in $NGINX_MODULES_DYN; do
#			if [ "${mod}" == "${dm}" ]; then
#				dyn="=dynamic"
#			fi
#		done

		if use nginx_modules_http_${mod}; then
			http_enabled=1
#			myconf+=" --with-http_${mod}_module${dyn}"
			myconf+=" --with-http_${mod}_module"
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=" --with-http_realip_module"
	fi

# third-party modules
# WARNING!!! Modules (that checked with "(**)" comment) adding order IS IMPORTANT!

# (**) http_naxsi
# wants to be the first defined module...
	if use nginx_modules_http_naxsi; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_NAXSI_MODULE_WD}"
	fi

	if use nginx_modules_http_security ; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_SECURITY_MODULE_WD}/nginx/modsecurity"
	fi

# (**) http_ndk
	if use nginx_modules_http_ndk; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_NDK_MODULE_WD}"
		myconf+=" --add-module=${HTTP_NDK_MODULE_WD}"
	fi

# (**) http_set_misc
	if use nginx_modules_http_set_misc; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_SET_MISC_MODULE_WD}"
		myconf+=" --add-module=${HTTP_SET_MISC_MODULE_WD}"
	fi

# (**) http_echo
	if use nginx_modules_http_echo; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_ECHO_MODULE_WD}"
		myconf+=" --add-module=${HTTP_ECHO_MODULE_WD}"
	fi

# (**) http_memc
	if use nginx_modules_http_memc; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_MEMC_MODULE_WD}"
		myconf+=" --add-module=${HTTP_MEMC_MODULE_WD}"
	fi
# (**) http_lua
	if use nginx_modules_http_lua; then
		http_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$($(tc-getPKG_CONFIG) --variable libdir luajit)
			export LUAJIT_INC=$($(tc-getPKG_CONFIG) --variable includedir luajit)
		else
			export LUA_LIB=$($(tc-getPKG_CONFIG) --variable libdir lua)
			export LUA_INC=$($(tc-getPKG_CONFIG) --variable includedir lua)
		fi
#		myconf+=" --add-dynamic-module=${HTTP_LUA_MODULE_WD}"
		myconf+=" --add-module=${HTTP_LUA_MODULE_WD}"
	fi

# (**) http_lua_upstream
	if use nginx_modules_http_lua_upstream; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_LUA_UPSTREAM_MODULE_WD}"
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
#		myconf+=" --add-dynamic-module=${HTTP_ENCRYPTED_SESSION_MODULE_WD}"
		myconf+=" --add-module=${HTTP_ENCRYPTED_SESSION_MODULE_WD}"
	fi

# (**) http_headers_more
	if use nginx_modules_http_headers_more; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_HEADERS_MORE_MODULE_WD}"
		myconf+=" --add-module=${HTTP_HEADERS_MORE_MODULE_WD}"
	fi

# http_pagespeed
	if use nginx_modules_http_pagespeed; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_PAGESPEED_MODULE_WD}"
	fi

# (**) http_srcache
	if use nginx_modules_http_srcache; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_SRCACHE_MODULE_WD}"
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

# http_enmemcache
	if use nginx_modules_http_enmemcache; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_ENMEMCACHE_MODULE_WD}"
	fi

# http_tcpproxy
	if use nginx_modules_http_tcpproxy; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_TCPPROXY_MODULE_WD}"
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

# http_passenger
	if use nginx_modules_http_passenger; then
		http_enabled=1
#		for pass_wd in $(_ruby_each_implementation get_passenger_wd|grep -v 'Running .* phase for'); do
			myconf+=" --add-module=${HTTP_PASSENGER_MODULE_WD}/src/nginx_module"
#		done
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
#		myconf+=" --add-dynamic-module=${HTTP_ARRAY_VAR_MODULE_WD}"
		myconf+=" --add-module=${HTTP_ARRAY_VAR_MODULE_WD}"
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_FORM_INPUT_MODULE_WD}"
		myconf+=" --add-module=${HTTP_FORM_INPUT_MODULE_WD}"
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_ICONV_MODULE_WD}"
		myconf+=" --add-module=${HTTP_ICONV_MODULE_WD}"
	fi

# http_fancyindex
	if use nginx_modules_http_fancyindex; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_FANCYINDEX_MODULE_WD}"
	fi

# http_nchan
	if use nginx_modules_http_nchan; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_NCHAN_MODULE_WD}"
		myconf+=" --add-module=${HTTP_NCHAN_MODULE_WD}"
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_UPLOAD_PROGRESS_MODULE_WD}"
	fi

# http_cache_purge
	if use nginx_modules_http_cache_purge; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_CACHE_PURGE_MODULE_WD}"
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
#		myconf+=" --add-dynamic-module=${HTTP_AUTH_PAM_MODULE_WD}"
		myconf+=" --add-module=${HTTP_AUTH_PAM_MODULE_WD}"
	fi

	if use nginx_modules_http_redis; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_REDIS_MODULE_WD}"
	fi

	if use http || use http-cache; then
		http_enabled=1
	fi

	if use mail; then
		mail_enabled=1
	fi

	if use stream; then
		stream_enabled=1
	fi

# Broken in 1.11
#	if use rtmp ; then
#		http_enabled=1
##		myconf+=" --add-dynamic-module=${RTMP_MODULE_WD}"
#		myconf+=" --add-module=${RTMP_MODULE_WD}"
#	fi

	if use nginx_modules_http_sticky ; then
		http_enabled=1
		myconf+=" --add-module=${HTTP_STICKY_MODULE_WD}"
	fi

	if use nginx_modules_http_mogilefs ; then
		http_enabled=1
		# broken
		myconf+=" --add-module=${HTTP_MOGILEFS_MODULE_WD}"
	fi

	if use nginx_modules_http_ajp ; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_AJP_MODULE_WD}"
		myconf+=" --add-module=${HTTP_AJP_MODULE_WD}"
	fi

	if use nginx_modules_http_njs ; then
		http_enabled=1
#		myconf+=" --add-dynamic-module=${HTTP_NJS_MODULE_WD}/nginx"
		myconf+=" --add-module=${HTTP_NJS_MODULE_WD}/nginx"
	fi

	if use nginx_modules_http_auth_ldap; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_LDAP_MODULE_WD} )
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=" --without-http-cache"
		use ssl	&& myconf+=" --with-http_ssl_module"
	else
		myconf+=" --without-http --without-http-cache"
	fi

	use perftools	&& myconf+=" --with-google_perftools_module"
	use rrd		&& myconf+=" --add-module=${RRD_MODULE_WD}"

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
#=dynamic"
		use ssl && myconf+=" --with-mail_ssl_module"
	fi

# stream_lua
	if use nginx_modules_stream_lua; then
		stream_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$($(tc-getPKG_CONFIG) --variable libdir luajit)
			export LUAJIT_INC=$($(tc-getPKG_CONFIG) --variable includedir luajit)
		else
			export LUA_LIB=$($(tc-getPKG_CONFIG) --variable libdir lua)
			export LUA_INC=$($(tc-getPKG_CONFIG) --variable includedir lua)
		fi
#		myconf+=" --add-dynamic-module=${STREAM_LUA_MODULE_WD}"
		myconf+=" --add-module=${STREAM_LUA_MODULE_WD}"
	fi

	# stream modules
	for mod in $NGINX_MODULES_STREAM; do
		if use nginx_modules_stream_${mod}; then
			stream_enabled=1
		else
			myconf+=" --without-stream_${mod}_module"
		fi
	done

	if [ $stream_enabled ]; then
		myconf+=" --with-stream"
#=dynamic"
		use ssl && myconf+=" --with-stream_ssl_module"
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
		pushd "${HTTP_SECURITY_MODULE_WD}" &>/dev/null
		append-cflags "-I/usr/include/apache2";

		./autogen.sh
### QA: append-cflags doesn't work, since it works globbaly (and causes problems with c++ apps)
		CFLAGS="${CFLAGS} -Wno-implicit-function-declaration" econf \
			--enable-standalone-module \
			--enable-extentions \
			--enable-request-early \
			--disable-apache2-module \
			--disable-errors \
			$(use_enable pcre-jit) \
			$(use_enable pcre-jit pcre-study) \
			$(use_enable nginx_modules_http_lua lua-cache) || die "configure failed for mod_security"
		popd &>/dev/null
	fi

	if use nginx_modules_http_passenger; then
		# workaround on QA issues on passenger
		pushd "${HTTP_PASSENGER_MODULE_WD}" &>/dev/null
		einfo "Compiling Passenger support binaries"
		export USE_VENDORED_LIBEV=no USE_VENDORED_LIBUV=no
		rake nginx || die "Passenger premake for ${RUBY} failed!"
		popd &>/dev/null
	fi

	custom_econf \
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

	local sedargs=();
	sedargs+=(-e "s|${WORKDIR}|ext|g")
	use nginx_modules_http_security && \
		sedargs+=(-e "s|/${P}/|/|g;s|/nginx/modsecurity||g")
	use nginx_modules_http_njs && \
		sedargs+=(-e "s|/${P}/|/|g;s|(/njs-[^/]*)/nginx |\1 |g")
	use nginx_modules_http_naxsi && \
		sedargs+=(-e "s|/${P}/|/|g;s|/naxsi_src||g")
	use nginx_modules_http_passenger && \
		sedargs+=(-e "s|/${P}/|/|g;s|/src/nginx_module||g;s|/src_module||g;s|(passenger)-release|\1|")

	sed -i -r "${sedargs[@]}" "${S}/objs/ngx_auto_config.h"
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C

	if use nginx_modules_http_security; then
		append-cflags "-I/usr/include/apache2";
		emake -C "${HTTP_SECURITY_MODULE_WD}";
	fi

	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "emake failed"
}

passenger_install() {
	# dirty spike to make passenger installation each-ruby compatible
	pushd "${HTTP_PASSENGER_MODULE_WD}/src/nginx_module" &>/dev/null
	rake fakeroot \
		NATIVE_PACKAGING_METHOD=ebuild \
		FS_PREFIX="${PREFIX}/usr" \
		FS_DATADIR="${PREFIX}/usr/libexec" \
		FS_DOCDIR="${PREFIX}/usr/share/doc/${P}" \
		FS_LIBDIR="${PREFIX}/usr/$(get_libdir)" \
		RUBYLIBDIR="$(ruby_rbconfig_value 'archdir')" \
		RUBYARCHDIR="$(ruby_rbconfig_value 'archdir')" \
	|| die "Passenger installation for ${RUBY} failed!"
	popd &>/dev/null
}

src_install() {
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
		pushd "${S}/objs/src/http/modules/perl" &>/dev/null
		einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
		perl_delete_localpod
		popd &>/dev/null
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

# http_nchan
	if use nginx_modules_http_nchan; then
		docinto "${HTTP_NCHAN_MODULE_P}"
		dodoc "${HTTP_NCHAN_MODULE_WD}"/README.md
	fi

# http_upload_progress
	if use nginx_modules_http_upload_progress; then
		docinto "${HTTP_UPLOAD_PROGRESS_MODULE_P}"
		dodoc "${HTTP_UPLOAD_PROGRESS_MODULE_WD}"/README
	fi

# http_fancyindex
	if use nginx_modules_http_fancyindex; then
		docinto "${HTTP_FANCYINDEX_MODULE_P}"
		dodoc "${HTTP_FANCYINDEX_MODULE_WD}"/{README.rst,HACKING.md}
	fi

# http_ey_balancer
	if use nginx_modules_http_ey_balancer; then
		docinto "${HTTP_EY_BALANCER_MODULE_P}"
		dodoc "${HTTP_EY_BALANCER_MODULE_WD}"/README
	fi

# http_ndk
	if use nginx_modules_http_ndk; then
		docinto "${HTTP_NDK_MODULE_P}"
		dodoc "${HTTP_NDK_MODULE_WD}"/README.md
	fi

# http_headers_more
	if use nginx_modules_http_headers_more; then
		docinto "${HTTP_HEADERS_MORE_MODULE_P}"
		dodoc "${HTTP_HEADERS_MORE_MODULE_WD}"/README.markdown
	fi

# http_encrypted_session
	if use nginx_modules_http_encrypted_session; then
		docinto "${HTTP_ENCRYPTED_SESSION_MODULE_P}"
		dodoc "${HTTP_ENCRYPTED_SESSION_MODULE_WD}"/README.md
	fi

# http_lua
	if use nginx_modules_http_lua; then
		docinto "${HTTP_LUA_MODULE_P}"
		dodoc "${HTTP_LUA_MODULE_WD}"/README.markdown
	fi

# stream_lua
	if use nginx_modules_stream_lua; then
		docinto "${STREAM_LUA_MODULE_P}"
		dodoc "${STREAM_LUA_MODULE_WD}"/{valgrind.suppress,README.md}
	fi

# http_lua_upstream
	if use nginx_modules_http_lua_upstream; then
		docinto "${HTTP_LUA_UPSTREAM_MODULE_P}"
		dodoc "${HTTP_LUA_UPSTREAM_MODULE_WD}"/README.md
	fi

# http_replace_filter
	if use nginx_modules_http_replace_filter; then
		docinto "${HTTP_REPLACE_FILTER_MODULE_P}"
		dodoc "${HTTP_REPLACE_FILTER_MODULE_WD}"/README.markdown
	fi

# http_form_input
	if use nginx_modules_http_form_input; then
		docinto "${HTTP_FORM_INPUT_MODULE_P}"
		dodoc "${HTTP_FORM_INPUT_MODULE_WD}"/README.md
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

# http_redis
	if use nginx_modules_http_redis; then
		docinto "${HTTP_REDIS_MODULE_P}"
		dodoc "${HTTP_REDIS_MODULE_WD}"/README.markdown
	fi

# http_drizzle
	if use nginx_modules_http_drizzle; then
		docinto "${HTTP_DRIZZLE_MODULE_P}"
		dodoc "${HTTP_DRIZZLE_MODULE_WD}"/README.markdown
	fi

# http_rds_json
	if use nginx_modules_http_rds_json; then
		docinto "${HTTP_RDS_JSON_MODULE_P}"
		dodoc "${HTTP_RDS_JSON_MODULE_WD}"/README.md
	fi

# http_rds_csv
	if use nginx_modules_http_rds_csv; then
		docinto "${HTTP_RDS_CSV_MODULE_P}"
		dodoc "${HTTP_RDS_CSV_MODULE_WD}"/README.md
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
		dodoc "${HTTP_XSS_MODULE_WD}"/README.md
	fi

# http_array_var
	if use nginx_modules_http_array_var; then
		docinto "${HTTP_ARRAY_VAR_MODULE_P}"
		dodoc "${HTTP_ARRAY_VAR_MODULE_WD}"/README.md
	fi

# http_iconv
	if use nginx_modules_http_iconv; then
		docinto "${HTTP_ICONV_MODULE_P}"
		dodoc "${HTTP_ICONV_MODULE_WD}"/README.markdown
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

#	if use rtmp; then
#		docinto "${RTMP_MODULE_P}"
#		dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
#	fi

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
		dodoc "${HTTP_AUTH_PAM_MODULE_WD}"/{README.md,ChangeLog}
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
		dodoc "${HTTP_AJP_MODULE_WD}"/README*
	fi

	if use nginx_modules_http_njs; then
		docinto ${HTTP_NJS_MODULE_P}
		dodoc "${HTTP_NJS_MODULE_WD}"/README
	fi

	if use nginx_modules_http_auth_ldap; then
		docinto ${HTTP_LDAP_MODULE_P}
		dodoc "${HTTP_LDAP_MODULE_WD}"/example.conf
	fi
}

pkg_postinst() {
	if use ssl; then
		if [ ! -f "${EROOT}"/etc/ssl/"${PN}"/"${PN}".key ]; then
			install_cert /etc/ssl/"${PN}"/"${PN}"
			use prefix || chown "${HTTPD_USER:-$PN}":"${HTTPD_GROUP:-$PN}" "${EROOT}"/etc/ssl/"${PN}"/"${PN}".{crt,csr,key,pem}
		fi
	fi

	if use nginx_modules_http_lua && use nginx_modules_http_v2; then
		ewarn
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua v2\". For more info, see http://git.io/OldLsg"
	fi

	if use nginx_modules_http_passenger; then
		ewarn
		ewarn "Please, keep notice, that 'passenger_root' directive"
		ewarn "should point to exactly location of 'locations.ini'"
		ewarn "file from this package (i.e. it should be full path)"
	fi

	# If the nginx user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c 'cd /var/log/${PN}/ && ls' "${HTTPD_USER:-$PN}" >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn
		ewarn "Please make sure that the nginx user (${HTTPD_USER:-$PN}) or group (${HTTPD_GROUP:-$PN}) has at least"
		ewarn "'rx' permissions on /var/log/${PN} (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi
}

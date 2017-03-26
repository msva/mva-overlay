# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx.eclass
# @MAINTAINER:
# mva <eclass.overlay@mva.name>
# @BLURB: This eclass provides functions to build all submodules for
# www-servers/nginx package
# @DESCRIPTION:
# This eclass provides functions to build all submodules for www-servers/nginx
# Original Author: mva <eclass.overlay@mva.name>
# Purpose:

###
# variable declarations
###


# Eclass exported functions
EXPORT_FUNCTIONS src_prepare src_configure

nginx_add_plugin() {
	MODULE_NAME="${1}"
	MODULE_AUTHOR="${2}"
	MODULE_PV="${3}"
	MODULE_SHA1="${4}"
	MODULE_P="${MODULE_NAME}-${MODULE_PV}"
	MODULE_PB="${MODULE_AUTHOR}-${MODULE_NAME}-${MODULE_SHA1}"
}

nginx_src_prepare() {

}

nginx_src_configure() {

}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# @ECLASS: npmv1.eclass
# @MAINTAINER:
# Vadim Misbakh-Soloviov mva<at>gentoo.org
# @AUTHOR:
# Geaaru geaaru<at>gmail.com
# @BLURB: npm handler
# @DESCRIPTION:
# Purpose: Manage installation of nodejs application with automatic
#          download of the modules defined on package.json file.

if has "${EAPI:-0}" 5; then
    inherit multilib
#else
    # POST: get_libdir is now part of EAPI.
    # https://blogs.gentoo.org/mgorny/2015/11/13/the-ultimate-guide-to-eapi-6/
fi

# TODO:
#  * support multi slot ebuilds
#
# ECLASS VARIABLES:
#  * NPM_DEFAULT_OPTS:   Contains options used with npm program to download nodejs modules of
#                        the package. Default values are: "-E --no-optional --production"
#  * NPM_PKG_NAME:       Contains package name. Default value is ${PN}.
#  * NPM_PACKAGEDIR:     Contains default install directory of the package.
#                        Default value is: ${EROOT}usr/$(get_libdir)/node_modules/${NPM_PKG_NAME}/
#  * NPM_GITHUP_MOD:     For nodejs module available on github identify user and module for
#                        automatically create SRC_URI.
#  * NPM_BINS:           If defined contains list of file used as binaries. Syntax could be
#                        the simple file name of if binary must be renamed syntax could be like this:
#                        NPM_BINS="
#                            origin_bin => install_bins
#                        "
#                        NOTE: Every binary is installed under bin directory of NPM_PACKAGEDIR
#                              For binary under /usr/bin is created a bash script where is
#                              initialized NODE_PATH variable to use first ${NPM_PACKAGEDIR}/node_modules
#                              directory and then system node_modules directory.
#                        To avoid install of all binaries use NPM_BINS="".
#  * NPM_SYSTEM_MODULES: If defined permit to avoid install of the packages modules to insert
#                        on this variable. This permit to use module installed from another ebuild.
#                        When this options is used NPM_NO_DEPS must be with value a 0 or not present.
#  * NPM_LOCAL_MODULES:  It works in opposite of NPM_SYSTEM_MODULES to define modules that are installed
#                        locally on package directory and avoid use of system installed packages.
#                        It used always for sub-packages/sub-directories modules.
#                        When this options is used NPM_NO_DEPS must be with value a 0 or not present.
#  * NPM_PKG_DIRS:       Permit of defines additional directories or files to intall. Default install directory
#                        if available is lib directory.
#  * NPM_NO_DEPS:        If present and with value equal to 1 then disable download of node modules
#                        dependencies and install of node_modules directory.
#  * NPM_GYP_BIN:        Path of node-gyp program.
#  * NPM_GYP_PKG:        Identify if package has source to compile with node-gyp (value 1) or not (value 0).
#                        Default value is 0
#  * NPM_NO_MIRROR:      Boolean value that add RESTRICT="mirror" for download package from SRC_URI.
#                        Default is True. Set to False to try to download package from gentoo mirrors.
#  * NPM_PV              Define version used for download sources when NPM_GITHUP_MOD is used.
#                        Default value is "v${PV}".

_npmv1_set_metadata() {
	if has "${EAPI:-0}" 5 6 7 8; then

		DEPEND="${DEPEND}
		net-libs/nodejs[npm(+)]
		"
		if [[ -z "${NPM_DEFAULT_OPTS}" ]] ; then
			NPM_DEFAULT_OPTS="-E --no-optional --production"
		fi
		if [[ -z "${NPM_PKG_NAME}" ]] ; then
			NPM_PKG_NAME="${PN}"
		fi

		if [ -z "${NPM_PV}" ] ; then
			NPM_PV="v${PV}"
		fi

		if [[ -z "${RESTRICT}" ]] ; then
			if [[ -z "${NPM_NO_MIRROR}" || "${NPM_NO_MIRROR}" == true  ]] ; then
				if [ -n "$RESTRICT" ] ; then
					RESTRICT="$RESTRICT mirror"
				else
					RESTRICT="mirror"
				fi
			fi
		fi
		if [[ -z "${SRC_URI}" && -z "${EGIT_REPO_URI}" ]] ; then
			if [[ -n "${NPM_GITHUP_MOD}" ]] ; then
				SRC_URI="https://github.com/${NPM_GITHUP_MOD}/archive/${NPM_PV}.zip -> ${PF}.zip"
			else
				SRC_URI="http://registry.npmjs.org/${NPM_PKG_NAME}/-/${NPM_PKG_NAME}-${PV}.tgz"
			fi
		fi
	else
		die "EAPI ${EAPI} is not supported!"
	fi

	# Avoid use of both NPM_SYSTEM_MODULES and NPM_LOCAL_MODULES
	[[ -n "${NPM_SYSTEM_MODULES}" && -n "${NPM_LOCAL_MODULES}" ]] && \
		die "Both NPM_LOCAL_MODULES and NPM_SYSTEM_MODULES variables defined!"
}

_npmv1_set_metadata
unset -f _npmv1_set_metadata

EXPORT_FUNCTIONS src_prepare src_compile src_install

# @FUNCTION: npmv1_src_prepare
# @DESCRIPTION:
# Implementation of src_prepare() phase. This function is exported.
npmv1_src_prepare() {
	# I'm on ${S}

	# Check if present package.json
	test -f package.json || die "package.json not found in package ${PN}"

	# Check if there are source to compile with node-gyp
	# TODO:
	if [ -f binding.gyp ] ; then
		NPM_GYP_PKG=1
	else
		NPM_GYP_PKG=0
	fi

	if [[ ${EAPI} -ge 6 ]]; then
		eapply_user
	else
		epatch_user
	fi
}

# @FUNCTION: npmv1_src_configure
# @DESCRIPTION:
# Implementation of src_compile() phase. This function is exported.
npmv1_src_compile() {
	if [[ -z "${NPM_GYP_BIN}" ]] ; then
		NPM_GYP_BIN="${EROOT}/usr/$(get_libdir)/node_modules/npm/bin/node-gyp-bin/node-gyp"
	fi

	if [[ x"${NPM_NO_DEPS}" != x"1" ]] ; then
		npm ${NPM_DEFAULT_OPTS} install || die "Error on download node modules!"
	else
		if [[ "${NPM_GYP_PKG}" -eq 1 ]] ; then
			${NPM_GYP_BIN} rebuild || die "Error on compile package ${PN} sources!."
		fi
	fi
}

# @FUNCTION: npmv1_src_install
# @DESCRIPTION:
# Implementation of src_compile() phase. This function is exported.
npmv1_src_install() {
	local words=""
	local sym=""
	local i=0
	local npm_root_js_files=""
	local npm_pkg_mods=""
	local npm_sys_mods=""

	if [[ -z "${NPM_PACKAGEDIR}" ]] ; then
		NPM_PACKAGEDIR="${EROOT}/usr/$(get_libdir)/node_modules/${NPM_PKG_NAME}"
	fi

	_npmv1_install_native_objs () {
		cp -rf build/ "${D}/${NPM_PACKAGEDIR}/" || die "Error on install native objects."
		return 0
	}

	_npmv1_create_bin_script () {
		local binfile=$1
		local bindir="$2"
		local scriptname="$3"
		local has_envheader="$4"
		local nodecmd=""

		if [[ ! -e "${ED}/usr/bin" ]] ; then
			mkdir -p "${ED}/usr/bin"
		fi

		if [[ ${has_envheader} -eq 0 ]] ; then
			nodecmd="node "
		fi

		echo \
"#!/bin/bash
# Author: geaaru@gmail.com
# Description: Autogenerated script from npmv1 eclass for package ${PN}.

def_node_path="${EROOT}/usr/$(get_libdir)/node_modules/"
app_node_path="${NPM_PACKAGEDIR}/node_modules/"

export NODE_PATH=\${app_node_path}:\${def_node_path}

${nodecmd}${bindir}/${binfile} \$@
" >     "${ED}/usr/bin/${scriptname}" || return 1

		chmod a+x "${ED}/usr/bin/${scriptname}" || return 1

		return 0
	}

	_npmv1_install_module () {
		local mod=$1
		# mode: 0 -> use NPM_SYSTEM_MODULES, 1 -> use NPM_LOCAL_MODULES
		local mode=${2:-0}
		local mod2install=true
		local i=0
		local sym=""
		local words=""
		local f=""

		if [ $mode = "0" ] ; then
			# Check if present on system module
			for i in ${!npm_sys_mods[@]} ; do
				if [[ ${mod} = ${npm_sys_mods[$i]} ]] ; then
					mod2install=false
					break
				fi
			done
		else
			mod2install=false
			# Check if present on local module
			for i in ${!npm_local_mods[@]} ; do
				if [[ ${mod} = ${npm_local_mods[$i]} ]] ; then
					mod2install=true
					break
				fi
			done
		fi

		if [[ $mod2install = true ]] ; then
			# Install package modules
			dodir ${NPM_PACKAGEDIR}/node_modules/

			echo "Injecting node_modules ${mod}..."
			cp -rf ./node_modules/"${mod}" "${D}""${NPM_PACKAGEDIR}"/node_modules/ || \
				die "Error on install module ${mod}."
		fi

		return 0
	}

	_npmv1_copy_root_js_files () {
		local i=0
		if [[ ${#npm_root_js_files[@]} -gt 0 ]] ; then

			for i in ${!npm_root_js_files[@]} ; do
				into ${NPM_PACKAGEDIR}
				doins ${npm_root_js_files[$i]} || \
					die "Error on install file ${npm_root_js_files[$i]}"
			done # end for i ..
		fi
	}

	_npmv1_copy_dirs() {
		local i=0
		local npm_other_dirs=( ${NPM_PKG_DIRS} )

		if [[ ${#npm_other_dirs[@]} -gt 0 ]] ; then

			# Install package modules
			dodir "${NPM_PACKAGEDIR}"

			for i in ${!npm_other_dirs[@]} ; do
				cp -rf ${npm_other_dirs[$i]} "${D}/${NPM_PACKAGEDIR}" || die "Error on copy directory ${npm_other_dirs[$i]}!"
			done # end for i ..
		fi
	}

	if [ -n "${NPM_BINS}" ] ; then
		# Install only defined binaries

		while read line ; do
			words=( ${line} )
			sym=""
			f=""

			if [ ${#line} -gt 1 ] ; then
				if [[ $line =~ .*\=\>.* ]] ; then
					# With rename
					[ ${#words[@]} -lt 3 ] && \
						die "Invalid binary row $line [${#words[@]}]."
					sym=${words[2]}
					f=${words[0]}
				else
					# Without rename
					[ ${#words[@]} -gt 1 ] && \
						die "Invalid binary row $line."
					sym=${line}
					f=${line}
				fi
			fi

			if [[ x"${f}" = x ]] ; then
				# Handle NPM_BINS empty for avoid install
				# of binaries files
				continue
			fi

			if [ -f "${S}/bin/${f}" ] ; then
				exeinto ${NPM_PACKAGEDIR}/bin/
				doexe "${S}/bin/${f}" || die "Error on install $f."

				# Check if binary has right header
				has_envheader=$(head -n 1 "${S}/bin/${f}" | grep node --color=none  | wc -l)

				_npmv1_create_bin_script "${f}" "${NPM_PACKAGEDIR}/bin" "${sym}" "${has_envheader}" || \
					die "Error on create binary script for ${f}."
			else
				if [ -f "${S}/${f}" ] ; then
					exeinto "${NPM_PACKAGEDIR}/"
					doexe "${S}/${f}" || die "Error on install $f."

					# Check if binary has right header
					has_envheader=$(head -n 1 "${S}/${f}" | grep node --color=none  | wc -l)
					_npmv1_create_bin_script "${f}" "${NPM_PACKAGEDIR}" "${sym}" "${has_envheader}" || \
						die "Error on create binary script for ${f}."
				else
					die "Binary ${f} is not present."
				fi
			fi # end if [ -e ${S}/bin/${f}
		done <<<"${NPM_BINS}"
	else
		for f in "${S}"/bin/* ; do
			local fname=$(basename ${f})

			if [ -e ${f} ] ; then
				exeinto "${NPM_PACKAGEDIR}/bin/"
				doexe "${f}" || die "Error on install $f."
				_npmv1_create_bin_script "${fname}" "${NPM_PACKAGEDIR}/bin" "${fname}" || \
					die "Error on create binary script for ${fname}."
			fi
		done # end for
	fi

	insinto "${NPM_PACKAGEDIR}"
	doins package.json

	if [[ x"${NPM_NO_DEPS}" != x"1" ]] ; then
		# Store list of package modules on npm_pkg_mods array
		npm_pkg_mods=( $(ls --color=none node_modules/) )

		if [[ -n "${NPM_SYSTEM_MODULES}" ]] ; then
			# Install package modules
			dodir "${NPM_PACKAGEDIR}/node_modules/"

			# Create an array with all modules to exclude from copy
			npm_sys_mods=( ${NPM_SYSTEM_MODULES} )

			for i in ${!npm_pkg_mods[@]} ; do
				_npmv1_install_module "${npm_pkg_mods[$i]}"
			done
		else
			if [ -n "${NPM_LOCAL_MODULES}" ] ; then

				# Create an array with all modules to include locally
				npm_local_mods=( ${NPM_LOCAL_MODULES} )

				for i in ${!npm_pkg_mods[@]} ; do
					_npmv1_install_module "${npm_pkg_mods[$i]}" "1"
				done
			else
				if [[ ${NPM_GYP_PKG} -ne 1 ]] ; then
					# If NPM_SYSTEM_MODULES is not present
					# and NPM_GYP_PKG is equal to 1
					# then doesn't install dependencies.

					if [[ ${#npm_pkg_mods[@]} -gt 0 ]] ; then
						# Install package modules
						dodir "${NPM_PACKAGEDIR}/node_modules/"

						cp -rf node_modules/* "${D}/${NPM_PACKAGEDIR}/node_modules/"
					fi
				fi
			fi
		fi
	fi # End if x"${NPM_NO_DEPS}" != x"1" ...

	# Copy all .js from root directory
	npm_root_js_files=( $(ls --color=none . | grep --color=none "\.js$") )
	_npmv1_copy_root_js_files

	# Copy library directory
	if [[ -d lib ]] ; then
		cp -rf lib "${D}/${NPM_PACKAGEDIR}" || die "Error on copy directory lib!"
	fi

	# Check if are present additional directories to copy
	if [[ -n "${NPM_PKG_DIRS}" ]] ; then
		_npmv1_copy_dirs
	fi

	if [[ ${NPM_GYP_PKG} -eq 1 ]] ; then
		_npmv1_install_native_objs
	fi

	for f in ChangeLog CHANGELOG.md LICENSE.md LICENSE LICENSE.txt REAME README.md ; do
		[[ -e ${f} ]] && dodoc ${f}
	done # end for

	unset -f _npmv1_create_bin_script
	unset -f _npmv1_install_module
	unset -f _npmv1_copy_root_js_files
	unset -f _npmv1_copy_dirs
	unset -f _npmv1_install_native_objs
}

# vim: ts=4 sw=4 expandtab

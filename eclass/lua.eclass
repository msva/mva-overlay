# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lua.eclass
# @MAINTAINER:
# Vadim A. Misbakh-Soloviov (mva) <lua@mva.name>
# @AUTHOR:
# Vadim A. Misbakh-Soloviov (mva) <lua@mva.name>
# (partially based on ruby and python eclasses)
# @BLURB: An eclass for installing Lua packages with proper support for multiple Lua slots.
# @DESCRIPTION:
# The Lua eclass is designed to allow an easier installation of Lua packages
# and their incorporation into the Gentoo Linux system.
#
# Currently available targets are:
#  * lua51 - Lua (PUC-Rio) 5.1
#  * lua52 - Lua (PUC-Rio) 5.2
#  * lua53 - Lua (PUC-Rio) 5.3
#  * luajit2 - LuaJIT 2.x
#
# This eclass does not define the implementation of the configure,
# compile, test, or install phases. Instead, the default phases are
# used.  Specific implementations of these phases can be provided in
# the ebuild either to be run for each Lua implementation, or for all
# Lua implementations, as follows:
#
#  * each_lua_configure
#  * all_lua_configure

# @ECLASS-VARIABLE: LUA_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a space separated list of targets (see above) a package
# is compatible to. It must be set before the `inherit' call.
: ${LUA_COMPAT:=lua51 lua52 lua53 luajit2}

# @ECLASS-VARIABLE: LUA_OPTIONAL
# @DESCRIPTION:
# Set the value to "yes" to make the dependency on a Lua interpreter
# optional and then lua_implementations_depend() to help populate
# DEPEND and RDEPEND.

# @ECLASS-VARIABLE: LUA_S
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable determines the source directory name after
# unpacking. This defaults to the name of the package. Note that this
# variable supports a wildcard mechanism to help with github tarballs
# that contain the commit hash as part of the directory name.

# @ECLASS-VARIABLE: LUA_QA_ALLOWED_LIBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable contains a whitelist of shared objects that
# are allowed to exist even if they don't link to liblua. This avoids
# the QA check that makes this mandatory. This is most likely not what
# you are looking for if you get the related "Missing links" QA warning,
# since the proper fix is almost always to make sure the shared object
# is linked against liblua. There are cases were this is not the case
# and the shared object is generic code to be used in some other way.
# When set this argument is passed to "grep -E" to remove reporting of
# these shared objects.

: ${GLOBAL_CFLAGS:=${CFLAGS}}
: ${GLOBAL_CXXFLAGS:=${CXXFLAGS}}
: ${GLOBAL_LDFLAGS:=${LDFLAGS}}

: ${NOCCACHE:=false}
: ${NODISTCC:=false}

[[ -n "${IS_MULTILIB}" ]] && multilib="multilib-minimal"


case ${VCS} in
	git)
		VCS="git-r3"
		;;
	hg)
		VCS="mercurial"
		;;
	svn)
		VCS="subversion"
		;;
esac

[[ -n "${GITHUB_A}" && -n "${BITBUCKET_A}" ]] && die "Only one of GITHUB_A or BITBUCKET_A should be set!"
if [[ -n "${GITHUB_A}" ]]; then
	GITHUB_PN="${GITHUB_PN:-${PN}}"
	EVCS_URI="https://github.com/${GITHUB_A}/${GITHUB_PN}"
	DL="archive"
elif [[ -n "${BITBUCKET_A}" ]]; then
	BITBUCKET_PN="${BITBUCKET_PN:-${PN}}"
	EVCS_URI="https://bitbucket.org/${BITBUCKET_A}/${BITBUCKET_PN}"
	DL="get"
fi
if [[ -z "${EGIT_REPO_URI}" && -z "${EHG_REPO_URI}" && -z "${SRC_URI}" && -n "${EVCS_URI}" ]]; then
	if [[ "${VCS}" = git* ]]; then
		EGIT_REPO_URI="${EVCS_URI}"
	elif [[ "${VCS}" = "mercurial" ]]; then
		EHG_REPO_URI="${EVCS_URI}"
	elif [[ -z "${VCS}" && "${PV}" != *9999* ]]; then
		SRC_URI="${EVCS_URI}/${DL}/${GITHUB_PV:-${PV}}.tar.gz -> ${P}.tar.gz"
	fi
fi

inherit eutils ${multilib} toolchain-funcs flag-o-matic ${VCS} patches

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_setup src_test

case ${EAPI:-0} in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI} (too old) for lua.eclass"
		;;
	4|5|6|7)
		# S is no longer automatically assigned when it doesn't exist.
		S="${WORKDIR}"
		;;
	*)
		ewarn "Unknown EAPI=${EAPI} for lua.eclass. Some things may become broken"
		ewarn "Please, review lua.eclass for compatibility with new EAPI"
		;;
esac

lua_implementation_depend() {
	local lua_pn=
	local lua_slot=

	case $1 in
		lua51)
			lua_pn="dev-lang/lua"
			lua_slot=":5.1"
			;;
		lua52)
			lua_pn="dev-lang/lua"
			lua_slot=":5.2"
			;;
		lua53)
			lua_pn="dev-lang/lua"
			lua_slot=":5.3"
			;;
		luajit2)
			lua_pn="dev-lang/luajit"
			lua_slot=":2"
			;;
		*) die "$1: unknown Lua implementation"
	esac

	echo "$2${lua_pn}$3${lua_slot}"
}

# @FUNCTION: lua_implementation_command
# @RETURN: the path to the given lua implementation
# @DESCRIPTION:
lua_implementation_command() {
	local _lua_name=
	local _lua_slotted=$(lua_implementation_depend $1)
	_lua_name=${_lua_slotted//:}

	case $1 in
		luajit*)
			_lua_name=${_lua_slotted/:/-}
			;;
	esac

	local lua=$(readlink -fs $(type -p $(basename ${_lua_name:-lua} 2>/dev/null)) 2>/dev/null)
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"
	echo "${lua}"
}

# @FUNCTION: lua_samelib
# @RETURN: use flag string with current lua implementations
# @DESCRIPTION:
# Convenience function to output the use dependency part of a
# dependency. Used as a building block for lua_add_rdepend() and
# lua_add_bdepend(), but may also be useful in an ebuild to specify
# more complex dependencies.
lua_samelib() {
	local res=
	for _lua_implementation in $LUA_COMPAT; do
		has -${_lua_implementation} $@ || \
			res="${res}lua_targets_${_lua_implementation}?,"
	done

	echo "[${res%,}]"
}

_lua_atoms_samelib_generic() {
	eshopts_push -o noglob
	echo "LUATARGET? ("
	for token in $*; do
		case "$token" in
			"||" | "(" | ")" | *"?")
				echo "${token}"
				;;
			*])
				echo "${token%[*}[LUATARGET,${token/*[}"
				#"]}" # <- kludge for vim's syntax highlighting engine to don't mess up all the things below this line
				;;
			*)
				echo "${token}[LUATARGET]"
				;;
		esac
	done
	echo ")"
	eshopts_pop
}

_lua_atoms_samelib() {
	local atoms=$(_lua_atoms_samelib_generic "$*")

	for _lua_implementation in $LUA_COMPAT; do
		echo "${atoms//LUATARGET/lua_targets_${_lua_implementation}}"
	done
}

_lua_wrap_conditions() {
	local conditions="$1"
	local atoms="$2"

	for condition in $conditions; do
		atoms="${condition}? ( ${atoms} )"
	done

	echo "$atoms"
}

# @FUNCTION: lua_add_rdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to RDEPEND,
# taking the current set of lua targets into account. This makes sure
# that all lua dependencies of the package are installed for the same
# lua targets. Use this function for all lua dependencies instead of
# setting RDEPEND yourself. The list of atoms uses the same syntax as
# normal dependencies.
#
# Note: runtime dependencies are also added as build-time test
# dependencies.
lua_add_rdepend() {
	case $# in
		1) ;;
		2)
			[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in lua_add_rdepend for $CATEGORY/$PF"
			lua_add_rdepend "$(_lua_wrap_conditions "$1" "$2")"
			return
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_lua_atoms_samelib "$1")

	RDEPEND="${RDEPEND} $dependency"

	# Add the dependency as a test-dependency since we're going to
	# execute the code during test phase.
	DEPEND="${DEPEND} test? ( ${dependency} )"
	has test "$IUSE" || IUSE="${IUSE} test"
}

# @FUNCTION: lua_add_bdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to DEPEND,
# taking the current set of lua targets into account. This makes sure
# that all lua dependencies of the package are installed for the same
# lua targets. Use this function for all lua dependencies instead of
# setting DEPEND yourself. The list of atoms uses the same syntax as
# normal dependencies.
lua_add_bdepend() {
	case $# in
		1) ;;
		2)
			[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in lua_add_bdepend for $CATEGORY/$PF"
			lua_add_bdepend "$(_lua_wrap_conditions "$1" "$2")"
			return
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_lua_atoms_samelib "$1")

	DEPEND="${DEPEND} $dependency"
	RDEPEND="${RDEPEND}"
}

# @FUNCTION: lua_get_use_implementations
# @DESCRIPTION:
# Gets an array of lua use targets enabled by the user
lua_get_use_implementations() {
	local i=() implementation
	for implementation in ${LUA_COMPAT}; do
		if [[ -z "${LUA_IGNORE_TARGET_DUPLICATION}" ]] && [ "${implementation}" = "lua51" ] && in_iuse lua_targets_luajit2 && use lua_targets_luajit2 && use lua_targets_lua51; then
			ewarn "LuaJIT using same LMOD/CMOD install paths as lua51."
			ewarn "Lua target 'lua51' was skipped to avoid useless double compilation and file overwrites."
			ewarn "If you definitelly want to compile lua51 target for nothing (i.e. you're maintainer),"
			ewarn "then set LUA_IGNORE_TARGET_DUPLICATION variable to any value in make.conf or package.env"
			continue
		else
			use lua_targets_${implementation} && i+=("${implementation}")
		fi
	done
	echo ${i[@]}
}

# @FUNCTION: lua_get_use_targets
# @DESCRIPTION:
# Gets an array of lua use targets that the ebuild sets
lua_get_use_targets() {
	local t=() implementation
	for implementation in ${LUA_COMPAT}; do
		t+=("lua_targets_${implementation}")
	done
	echo ${t[@]}
}

# @FUNCTION: lua_implementations_depend
# @RETURN: Dependencies suitable for injection into DEPEND and RDEPEND.
# @DESCRIPTION:
# Produces the dependency string for the various implementations of lua
# which the package is being built against. This should not be used when
# LUA_OPTIONAL is unset but must be used if LUA_OPTIONAL=yes. Do not
# confuse this function with lua_implementation_depend().
#
# @EXAMPLE:
# EAPI=5
# LUA_OPTIONAL=yes
#
# inherit lua
# ...
# DEPEND="lua? ( $(lua_implementations_depend) )"
# RDEPEND="${DEPEND}"
lua_implementations_depend() {
	local depend
	for _lua_implementation in ${LUA_COMPAT}; do
		depend="${depend}${depend+ }lua_targets_${_lua_implementation}? ( $(lua_implementation_depend $_lua_implementation) )"
	done
	echo "${depend}"
}

IUSE+="$(lua_get_use_targets)"
# If you specify LUA_OPTIONAL you also need to take care of
# lua useflag and dependency.
if [[ ${LUA_OPTIONAL} != yes ]]; then
	DEPEND="${DEPEND} $(lua_implementations_depend)"
	RDEPEND="${RDEPEND} $(lua_implementations_depend)"
	REQUIRED_USE+=" || ( $(lua_get_use_targets) )"
fi

_lua_invoke_environment() {
	old_S=${S}
	if [ -z "${LUA_S}" ]; then
		sub_S=${P}
	else
		sub_S=${LUA_S}
	fi

	# Special case, for GitHub fetches of ancient packages. With this,
	# we allow the star glob to just expand to whatever directory it's
	# called.
	if [[ "${sub_S}" = *"*"* ]]; then
		pushd "${WORKDIR}"/all &>/dev/null
		sub_S=$(eval ls -d "${sub_S}" 2>/dev/null)
		popd &>/dev/null
	fi

	environment="${1}"; shift

	my_WORKDIR="${WORKDIR}"/"${environment}"
	S="${my_WORKDIR}"/"${sub_S}"
	EGIT_CHECKOUT_DIR="${S}"
	EHG_CHECKOUT_DIR="${S}"
	EBZR_UNPACK_DIR="${S}"
	BUILD_DIR="${S}"
	CMAKE_USE_DIR="${S}"

	if [[ -d "${S}" ]]; then
		pushd "$S" &>/dev/null
	elif [[ -d "${my_WORKDIR}" ]]; then
		pushd "${my_WORKDIR}" &>/dev/null
	else
		pushd "${WORKDIR}" &>/dev/null
	fi

	ebegin "Running ${_PHASE:-${EBUILD_PHASE}} phase for $environment"
	"$@"
	popd &>/dev/null

	S=${old_S}
}

_lua_each_implementation() {
	local invoked=no
	for _lua_implementation in $(lua_get_use_implementations); do
		LUA=$(lua_implementation_command ${_lua_implementation})
		TARGET=${_lua_implementation};
		lua_impl=$(basename ${LUA})
		invoked=yes

		if [[ -n "$1" ]]; then
			_lua_setFLAGS
			_lua_invoke_environment ${_lua_implementation} "$@"
		fi

		unset LUA TARGET
	done

	if [[ ${invoked} == "no" ]]; then
		eerror "You need to select at least one compatible Lua installation target via LUA_TARGETS in make.conf."
		eerror "Compatible targets for this package are: ${LUA_COMPAT}"
		eerror
		die "No compatible Lua target selected."
	fi
}

# @FUNCTION: lua_pkg_setup
# @DESCRIPTION:
# Check whether at least one lua target implementation is present.
lua_pkg_setup() {
	# This only checks that at least one implementation is present
	# before doing anything; by leaving the parameters empty we know
	# it's a special case.
	_lua_each_implementation
}

# @FUNCTION: lua_src_unpack
# @DESCRIPTION:
# Unpack the source archive.
lua_src_unpack() {
	mkdir "${WORKDIR}"/all
	pushd "${WORKDIR}"/all &>/dev/null

	# We don't support an each-unpack, it's either all or nothing!
	if type all_lua_unpack &>/dev/null; then
		_lua_invoke_environment all all_lua_unpack
	else
		if [[ -n ${A} ]]; then
			if declare -f unpacker_src_unpack >/dev/null; then
				_lua_invoke_environment all unpacker_src_unpack
			else
				unpack ${A}
			fi
		fi
		if [[ -n ${VCS} ]] && declare -f ${VCS}_src_unpack >/dev/null; then
			_lua_invoke_environment all ${VCS}_src_unpack
		elif [[ -z "${GITHUB_A}" && -z "${BITBUCKET_A}" && -z "${A}" ]]; then
				eerror "Either GITHUB_A or BITBUCKET_A (author nick) should be set for magic SRC/REPO URI filling to work"
				eerror "You should either set one of them, or fill the proper URI variable manually!"
				die "See above eerror messages."
		fi
	fi

	# hack for VCS-eclasses (darcs, for example) which defaults unpack dir to WD/P instead of S
	if [[ "${PV}" = *9999* ]] && [[ -d "${WORKDIR}/${P}" ]] && [[ ! -d "${WORKDIR}/all/${P}" ]] ; then
		mv "${WORKDIR}/${P}" "${WORKDIR}/all/${P}"
	elif [[ "${PV}" != *9999* ]] && [[ -n "${GITHUB_PV}" ]] && [[ -d "${WORKDIR}/all/${GITHUB_PN}-${GITHUB_PV}" ]] && [[ ! -d "${WORKDIR}/all/${P}" ]]; then
		mv "${WORKDIR}/all/${GITHUB_PN}-${GITHUB_PV}" "${WORKDIR}/all/${P}"
	fi

	popd &>/dev/null
}

_lua_source_copy() {
	# Until we actually find a reason not to, we use hardlinks, this
	# should reduce the amount of disk space that is wasted by this.
	cp -prlP all ${_lua_implementation} \
		|| die "Unable to copy ${_lua_implementation} environment"
}

_lua_get_lf() {
#	local lua=$(readlink -fs $(type -p $(basename ${LUA:-lua} 2>/dev/null)) 2>/dev/null)
	local lf;
	lf=$(sed -r -e "s@-llua @-l$(lua_get_lua) @" -e "s@(-L[^ ]*)lib[0-9]*([^ ]*)@\1$(get_libdir)\2@" <<< "$(${PKG_CONFIG} --libs ${lua_impl})")
	echo "${lf}"
}

_lua_get_cf() {
	echo "$(${PKG_CONFIG} --cflags ${lua_impl})"
}

_lua_setFLAGS() {
	unset PKG_CONFIG LD
# CC CXX CFLAGS CXXFLAGS LDFLAGS LUA_CF LUA_LF

	PKG_CONFIG="$(tc-getPKG_CONFIG)"
	CC="$(tc-getCC)"
	CXX="$(tc-getCXX)"
	LD="$(tc-getLD)"

	LUA_CF="$(_lua_get_cf)"
	LUA_LF="$(_lua_get_lf)"

	CFLAGS="${GLOBAL_CFLAGS} ${LUA_CF} -fPIC -DPIC"
	CXXFLAGS="${GLOBAL_CXXFLAGS} ${LUA_CF} -fPIC -DPIC"
	LDFLAGS="${GLOBAL_LDFLAGS} -shared -fPIC"

	export CC CXX LD CFLAGS CXXFLAGS LDFLAGS PKG_CONFIG LUA_LF
}

lua_is_jit() {
	if [[ "${TARGET}" =~ "luajit" ]]; then
		return 0
	else
		return 1
	fi
}

lua_default() {
	local phase rep phase_def_fn;
	rep=${FUNCNAME[1]%%_lua*};
	phase=${EBUILD_PHASE};
	phase_def_fn="_lua_default_${rep}_${phase}"

	declare -f ${phase_def_fn} >/dev/null && "${phase_def_fn}" "${@}"
}

# @FUNCTION: lua_src_prepare
# @DESCRIPTION:
# Apply patches and prepare versions for each lua target
# implementation. Also carry out common clean up tasks.
lua_src_prepare() {
	if [[ -n ${VCS} ]] && declare -f ${VCS}_src_prepare >/dev/null; then
		_lua_invoke_environment all ${VCS}_src_prepare
	fi

#	_lua_invoke_environment all default_src_prepare

	if ! declare -f all_lua_prepare >/dev/null; then
		all_lua_prepare() {
			lua_default
		}
	fi
	_lua_invoke_environment all all_lua_prepare


	if [[ -n ${IS_MULTILIB} ]]; then
		_PHASE="multilib sources copy" \
			_lua_invoke_environment all multilib_copy_sources
	fi

	_PHASE="sources copy" \
		_lua_each_implementation _lua_source_copy


	if ! declare -f each_lua_prepare >/dev/null; then
		each_lua_prepare() {
			lua_default
		}
	fi

	_lua_each_implementation each_lua_prepare
}

# @FUNCTION: lua_src_configure
# @DESCRIPTION:
# Configure the package.
lua_src_configure() {
	if ! declare -f each_lua_configure >/dev/null; then
		each_lua_configure() {
			lua_default
		}
	fi

	if [[ -n ${IS_MULTILIB} ]]; then
		multilib_src_configure() {
			each_lua_configure
		}
		_lua_each_implementation multilib-minimal_src_configure
	else
		_lua_each_implementation each_lua_configure
	fi
}

# @FUNCTION: lua_src_compile
# @DESCRIPTION:
# Compile the package.
lua_src_compile() {
	if ! declare -f each_lua_compile >/dev/null; then
		each_lua_compile() {
			lua_default
		}
	fi

	if [[ -n ${IS_MULTILIB} ]]; then
		multilib_src_compile() {
			each_lua_compile
		}
		_lua_each_implementation multilib-minimal_src_compile
	else
		_lua_each_implementation each_lua_compile
	fi

	if ! declare -f all_lua_compile >/dev/null; then
		all_lua_compile() {
			lua_default
		}
	fi
	_lua_invoke_environment all all_lua_compile
}

# @FUNCTION: lua_src_test
# @DESCRIPTION:
# Run tests for the package.
lua_src_test() {
	if ! declare each_lua_test >/dev/null; then
		each_lua_test() {
			lua_default
		}
	fi

	if [[ -n ${IS_MULTILIB} ]]; then
		multilib_src_test() {
			each_lua_test
		}
		_lua_each_implementation multilib-minimal_src_test
	else
		_lua_each_implementation each_lua_test
	fi

	if ! declare -f all_lua_test >/dev/null; then
		all_lua_test() {
			lua_default
		}
	fi
	_lua_invoke_environment all all_lua_test
}

# @FUNCTION: lua_src_install
# @DESCRIPTION:
# Install the package for each lua target implementation.
lua_src_install() {
	if ! declare -f each_lua_install >/dev/null; then
		each_lua_install() {
			lua_default
		}
	fi

	if ! declare -f all_lua_install >/dev/null; then
		all_lua_install() {
			lua_default
		}
	fi

	if [[ -n ${IS_MULTILIB} ]]; then
		multilib_src_install() {
			each_lua_install
		}
		multilib_src_install_all() {
			all_lua_install
		}
		_lua_each_implementation multilib-minimal_src_install
	else
		_lua_each_implementation each_lua_install
		_lua_invoke_environment all all_lua_install
	fi

#### TODO: move this things to more general eclass, like docs or so ####
	local README_DOCS OTHER_DOCS MY_S;

	README_DOCS=(${DOCS[@]});
	OTHER_DOCS=(${DOCS[@]//README*});
#	MY_S="${WORKDIR}/all/${P}"

	unset DOCS;

	for r in ${OTHER_DOCS[@]}; do
		README_DOCS=("${README_DOCS[@]//${r}}")

#		if [[ -d ${MY_S}/${r} ]]; then
##			for case if __strip_duplicate_slashes will be dropped from phase-helpers.sh:
##			local rd=$(dirname ${r}/i-need-to-remove-trailing-slash)
#			OTHER_DOCS=("${OTHER_DOCS[@]//${r}}")
#			for od in ${MY_S}/${r}/*; do
#				OTHER_DOCS+=("$(__strip_duplicate_slashes ${od#${MY_S}/})")
#			done
#		fi
	done;
	README_DOCS+=(${DOCS_FORCE[@]})

	if [[ -n "${HTML_DOCS}" ]] && ! use doc; then
		unset HTML_DOCS
	fi

	if [[ -n "${README_DOCS}" ]]; then
		export DOCS=(${README_DOCS[@]});
		_PHASE="install readmes and forced docs" _lua_invoke_environment all _lua_src_install_docs
		unset DOCS;
	fi

	if [[ -n "${OTHER_DOCS[@]}" || -n "${HTML_DOCS[@]}" ]] && use doc; then
		export DOCS=(${OTHER_DOCS[@]})
		_PHASE="install docs" _lua_invoke_environment all _lua_src_install_docs
		unset DOCS
	fi

	if [[ -n "${EXAMPLES[@]}" ]] && use examples; then
		_PHASE="install examples" _lua_invoke_environment all _lua_src_install_examples
	fi
#### END  ####
}

#### TODO: move this things to more general eclass, like docs or so ####
_lua_src_install_examples() {
	debug-print-function $FUNCNAME "$@"

	local x
#	local MY_S="${LUA_S:-${WORKDIR}/all/${P}}"

#	pushd "${MY_S}" >/dev/null

	if [[ "$(declare -p EXAMPLES 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${EXAMPLES[@]}"; do
			debug-print "$FUNCNAME: docs: creating examples from ${x}"
			docompress -x /usr/share/doc/${PF}/examples
			docinto examples
			dodoc -r "${x}"
		done
	fi

#	popd >/dev/null
}

_lua_src_install_docs() {
	debug-print-function $FUNCNAME "$@"
	local x

#	local MY_S;
#	if [[ -z "${LUA_S}" ]]; then
#		MY_S="${WORKDIR}/all/${P}"
#	else
#		MY_S="${WORKDIR}/all/${LUA_S}"
#	fi
#	pushd "${MY_S}" >/dev/null

	if [[ "$(declare -p DOCS 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${DOCS[@]}"; do
			debug-print "$FUNCNAME: docs: creating document from ${x}"
			docinto .
			dodoc -r "${x}"
		done
	fi
	if [[ "$(declare -p HTML_DOCS 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${HTML_DOCS[@]}"; do
			debug-print "$FUNCNAME: docs: creating html document from ${x}"
			docinto html
			dodoc -r "${x}"
		done
	fi

#	popd >/dev/null
}

#### END ####


# @FUNCTION: luainto
# @USAGE: path
# @DESCRIPTION:
# Specifies installation path (under INSTALL_?MOD) for "dolua*" functions
#luainto() {
#	_dolua_indir="${1}"
#}

newlua() {
	local tmp_S=$(mktemp -d -p ${T} tmp_S.${P}.XXXXX)
	local src="${1}"
	local dst="${2}"
	cp -rl "${src}" "${tmp_S}/${dst}"
	pushd "${tmp_S}" >/dev/null &&
	dolua "${dst}" &&
	popd >/dev/null &&
	rm -rf "${tmp_S}"
}

# @FUNCTION: dolua
# @USAGE: file [file...]
# @DESCRIPTION:
# Installs the specified file(s) into the proper INSTALL_?MOD location of the Lua interpreter in ${LUA}.
dolua() {
	local lmod=()
	local cmod=()
	for f in "$@"; do
		base_f="$(basename ${f})"
		case ${base_f} in
			*.so)
				cmod+=(${f})
				;;
			*)
				if [[ -d ${f} ]]; then
					local insdir="${_dolua_insdir}/${base_f}"
					_dolua_insdir="${insdir}" dolua "${f}"/*
				else
					lmod+=(${f})
				fi
				;;
		esac
	done
	test -n "${lmod}" && _dolua_insdir="${_dolua_insdir}" _lua_install_lmod ${lmod[@]}
	test -n "${cmod}" && _dolua_insdir="${_dolua_insdir}" _lua_install_cmod ${cmod[@]}
}

_lua_install_lmod() {
	has "${EAPI}" 2 && ! use prefix && EPREFIX=
	local insdir="$(lua_get_lmoddir)"
	[[ -n "${_dolua_insdir}" ]] && insdir="${insdir}/${_dolua_insdir}"
	(
		insinto ${insdir#${EPREFIX}}
		insopts -m 0644
		doins -r "$@"
	) || die "failed to install $@"
}

_lua_install_cmod() {
	has "${EAPI}" 2 && ! use prefix && EPREFIX=
	local insdir="$(lua_get_cmoddir)"
	[[ -n "${_dolua_insdir}" ]] && insdir="${insdir}/${_dolua_insdir}"
	(
		insinto ${insdir#${EPREFIX}}
		insopts -m 0644
		doins -r "$@"
	) || die "failed to install $@"
}

_lua_jit_insopts() {
	[[ "${LUA}" =~ "luajit" ]] || die "Calling dolua_jit for non-jit targets isn't supported"
	local insdir=$(${LUA} -e 'print(package.path:match(";(/[^;]+luajit[^;]+)/%?.lua;"))')
	insinto ${insdir#${EPREFIX}}/${_dolua_jit_insdir}
	insopts -m 0644
}

dolua_jit() {
	_lua_jit_insopts
	doins -r "$@"
}

newlua_jit() {
	_lua_jit_insopts
	newins "$@"
}

# @FUNCTION: lua_get_pkgvar
# @RETURN: The value of specified pkg-config variable for Lua interpreter in ${LUA}.
lua_get_pkgvar() {
	local var=$($(tc-getPKG_CONFIG) ${2:---variable} ${@} $(lua_get_lua))
	echo "${var}"
}

# @FUNCTION: lua_get_lmoddir
# @RETURN: The path for pure-lua modules installation for Lua interpreter in ${LUA}.
lua_get_lmoddir() {
	local ldir=$(lua_get_pkgvar INSTALL_LMOD)
	echo "${ldir}"
}

# @FUNCTION: lua_get_cmoddir
# @RETURN: The path for binary modules installation for Lua interpreter in ${LUA}.
lua_get_cmoddir() {
	local cdir=$(lua_get_pkgvar INSTALL_CMOD)
	echo "${cdir}"
}

# @FUNCTION: lua_get_lua
# @RETURN: The name of Lua interpreter in ${LUA}.
lua_get_lua() {
	[[ -z ${LUA} ]] && die "\$LUA is not set"
	local impl="${lua_impl:-$(basename ${LUA})}"
	echo "${impl}"
}

# @FUNCTION: lua_get_liblua
# @RETURN: The location of liblua*.so belonging to the Lua interpreter in ${LUA}.
lua_get_liblua() {
	local libdir="$(lua_get_pkgvar libdir)"
	local libname="$(lua_get_pkgvar libname)"
	libname="${libname:-lua$(lua_get_abi)}"
	echo "${libdir}/lib${libname}.so"
}

# @FUNCTION: lua_get_incdir
# @RETURN: The location of the header files belonging to the Lua interpreter in ${LUA}.
lua_get_incdir() {
	local incdir=$(lua_get_pkgvar includedir)
	echo "${incdir}"
}

# @FUNCTION: lua_get_abi
# @RETURN: The version of the Lua interpreter ABI in ${LUA}, or what 'lua' points to.
lua_get_abi() {
	local lua=${LUA:-$(type -p lua 2>/dev/null)}
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"
	echo $(${lua} -e 'print(_VERSION:match("[%d.]+"))')
}

# @FUNCTION: lua_get_implementation
# @RETURN: The implementation of the Lua interpreter in ${LUA}, or what 'lua' points to.
lua_get_implementation() {
	local lua=${LUA:-$(type -p lua 2>/dev/null)}
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"

	case $(${lua} -v) in
		LuaJIT*)
			echo "luajit"
			;;
		*)
			echo "lua"
			;;
	esac
}

_lua_default_all_prepare() {
	local prepargs=();
	prepargs+=(
		"${myeprepareargs[@]}"
		"${@}"
	)

	[[ -z "${__PATCHES_PREPARE_CALLED}" ]] && patches_src_prepare
	export __PATCHES_PREPARE_CALLED=1

	[[ -x "${BOOTSTRAP}" ]] && ${BOOTSTRAP} "${prepargs[@]}"

	for mf in Makefile GNUmakefile makefile; do
		if [[ -f "${mf}" ]]; then
			sed -i -r \
				-e '1iinclude .lua_eclass_config' \
				-e '/^CC[[:space:]]*=/d' \
				-e '/^LD[[:space:]]*=/d' \
				-e 's#(^CFLAGS[[:space:]]*)[[:punct:]]*=#\1+=#' \
				-e 's#(^CXXFLAGS[[:space:]]*)[[:punct:]]*=#\1+=#' \
				-e 's#(^LDFLAGS[[:space:]]*)[[:punct:]]*=#\1+=#' \
				-e 's#(^LFLAGS[[:space:]]*)[[:punct:]]*=#\1+=$(LDCONFIG)#' \
				-e 's#`pkg-config#`$(PKG_CONFIG)#g' \
				-e 's#(shell[[:space:][:punct:]]*)pkg-config#\1$(PKG_CONFIG)#g' \
				-e 's#-llua[[:digit:][:punct:]]*#__LESLPH__#g;s#__LESLPH__([[:alpha:]])#-llua\1#g;s#__LESLPH__#$(LUA_LINK_LIB)#g' \
				-e 's#lua5.[[:digit:]]#$(LUA_IMPL)#g' \
				"${mf}"
		fi
		touch ${T}/.lua_ecl_conf
	done
}

_lua_default_all_compile() {
	local doc_target="${DOC_MAKE_TARGET:=doc}"

	has doc ${IUSE} &&
	use doc &&
	grep -qs "${doc_target}[[:space:]]*:" {GNUm,m,M}akefile && (
		[[ -f ${T}/.lua_ecl_conf ]] && touch .lua_eclass_config
		emake "${doc_target[@]}"
	)
}

#lua_default_all_install() {
#
#}

_lua_default_each_configure() {
	_lua_setFLAGS
	local confargs=();
	confargs+=("${myeconfargs[@]}")
	confargs+=("${@}")

	(
		[[ -x ${ECONF_SOURCE:-.}/configure ]] &&
		[[ -z "${CUSTOM_ECONF}" ]]
	) &&
	econf "${confargs[@]}"

	if [[ -f ${T}/.lua_ecl_conf ]]; then
		touch .lua_eclass_config
		local ecl_confargs=();

		ecl_confargs+=(
			CC="${CC}"
			CXX="${CXX}"
			LD="${LD}"
			CFLAGS="${CFLAGS}"
			LDFLAGS="${LDFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			PKG_CONFIG="${PKG_CONFIG}"
			LUA_IMPL="$(lua_get_lua)"
			LUA_LINK_LIB="$(_lua_get_lf)"
		)

		ecl_confargs+=("${confargs[@]}")

		for carg in "${ecl_confargs[@]}"; do
			echo "${carg}" >> .lua_eclass_config
		done
	fi
}

_lua_default_each_compile() {
	local makeargs=();
	if has ccache ${FEATURES} && [[ "${NOCCACHE}" = "true" ]]; then
		export CCACHE_DISABLE=1;
	fi

	if has distcc ${FEATURES} && [[ "${NODISTCC}" = "true" ]]; then
		export DISTCC_DISABLE=1;
	fi

	if [[ -f Makefile || -f GNUmakefile || -f makefile ]]; then
		makeargs+=("${myemakeargs[@]}")
		makeargs+=("${@}")
		emake "${makeargs[@]}"
	fi

}

_lua_default_each_install() {
	local instargs=();
	if [[ -f Makefile || -f GNUmakefile || -f makefile ]]; then
		instargs+=(DESTDIR="${D}")
		instargs+=("${@}")
		instargs+=("${myeinstallargs[@]}")
		instargs+=("install")
		emake "${instargs[@]}"
	fi
}


# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gradle.eclass
# @MAINTAINER:
# Vadim Misbakh-Soloviov <mva@gentoo.org>
# @AUTHOR:
# VAdim Misbakh-Soloviov <mva@gentoo.org>
# @BLURB: gradle wrapper
# @DESCRIPTION:
# Trying to make gradle build to work.
# For now it just adds RESTRICT=network-sandbox, which is bad,
# but someday I hope to find a way to make it work properly.

if [[ -z ${_GRADLE_ECLASS} ]]; then
	_GRADLE_ECLASS=1
	# TODO: fix to work with network-sandbox

	RESTRICT="${RESTRICT} network-sandbox"

	egradle() {
		local gradle="/usr/bin/gradle"
		local gradle_args=(
			--console=rich
			--info
			--stacktrace
			--no-build-cache
			--no-daemon
			# --offline
			--gradle-user-home "${T}/gradle_user_home"
			--project-cache-dir "${T}/gradle_project_cache"
		)

		einfo "gradle "${gradle_args[@]}" ${@}"
		# TERM needed, otherwise gradle may fail on terms it does not know about
		TERM="dumb" "${gradle}" "${gradle_args[@]}" ${@} || die "gradle failed"
	}
fi


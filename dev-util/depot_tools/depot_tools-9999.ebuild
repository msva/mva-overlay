# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..13} )

inherit wrapper git-r3 python-r1

DESCRIPTION="Chromium scripts to manage interaction with dependencies"
HOMEPAGE="https://www.chromium.org/developers/how-tos/install-depot-tools/"
EGIT_REPO_URI="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
LICENSE="GPL-2"
SLOT="0"
IUSE="zsh-completion"
RDEPEND="
	${PYTHON_DEPS}
	dev-vcs/git
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS_DIR="${WORKDIR}/${P}-docs"
DOCS=( "${DOCS_DIR}"/README{,.gclient,.git-cl}.md "${DOCS_DIR}"/man/html )

pkg_pretend() {
	eerror "This package is currently kinda \"disabled\" (this code prevents it's installation)"
	eerror "The reason is that for now it has a problem with gn.py (and it's wrapper) calling itself recursively"
	eerror "(which causes billions of process and OOM'ing the system), for example during build of dev-qt/qtwebengine"
	die "If you need it in your work, please, help me to properly fix it"
}


src_prepare() {
	rm -f *.bat *.ps1 *.exe ninja* LICENSE .git{i,a}* update_depot_tools*
	rm -r win_toolchain bootstrap

	mkdir "${DOCS_DIR}" "${WORKDIR}/stuff"

	sed -n \
	-e '1p;/^base_dir/p;$p' \
	-i gclient

	echo > .disable_auto_update

	mv pylint pylint.google

	mv man README* "${DOCS_DIR}"
	mv zsh-goodies "${WORKDIR}/stuff"

	default
}

src_install() {
	local inspath=/usr/libexec/"${PN}"

	insinto "${inspath}"
	doins -r *

	exeinto "${inspath}"
	for py in *.py git-* wtf vpython cros cros_sdk chrome_set_ver cbuildbot; do
		local w="${py%%.py}"
		if [[ -f "${w}" ]]; then
			doexe "${w}"
			make_wrapper "$(basename ${w})" "${inspath}/${w}"
		fi
	done

#	make_wrapper "update_depot_tools" "echo -n" "" "" "${inspath}"

	# exeinto "${inspath}/support"
	# doexe support/chromite_wrapper
	# doexe repo

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins "${WORKDIR}"/stuff/zsh-goodies/_*
	fi

	python_foreach_impl python_fix_shebang -f -q "${D}${inspath}"
	python_foreach_impl python_optimize "${D}${inspath}"

	doman "${DOCS_DIR}/man/man"{1,7}/*

	einstalldocs
}

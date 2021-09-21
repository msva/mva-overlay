# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit eutils git-r3 python-r1

DESCRIPTION="Chromium scripts to manage interaction with dependencies"
HOMEPAGE="https://dev.chromium.org/developers/how-tos/install-depot-tools"
EGIT_REPO_URI="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="zsh-completion"
RDEPEND="
	dev-vcs/git
"
DEPEND="${RDEPEND}"

DOCS_DIR="${WORKDIR}/${P}-docs"
DOCS=( "${DOCS_DIR}"/README{{.gclient,.git-cl,}.md,.testing} "${DOCS_DIR}"/man/html )

src_prepare() {
	rm -f *.bat *.ps1 *.exe ninja* LICENSE .git{i,a}* update_depot_tools*
	rm -r win_toolchain bootstrap

	mkdir "${DOCS_DIR}" "${WORKDIR}/stuff"

	# FIXME: When depot_tools will be compatible with py3
	grep -rl 'exec python' | xargs sed \
		-e 's@exec python@exec python2@' -i
	#

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

	exeinto "${inspath}/support"
	doexe support/chromite_wrapper

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins "${WORKDIR}"/stuff/zsh-goodies/_*
	fi

	python_foreach_impl python_fix_shebang -f -q "${D}${inspath}"
	python_foreach_impl python_optimize "${D}${inspath}"

	doman "${DOCS_DIR}/man/man"{1,7}/*

	einstalldocs
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( pypy3 python3_{4,5,6,7} )
inherit eutils python-single-r1 systemd

DESCRIPTION="systemd units to create timers for cron directories and crontab"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron/"
if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/systemd-cron/${PN}"
else
	if [[ -d "${FILESDIR}/patches/${PV}" ]]; then
		PATCHES+=("${FILESDIR}/patches/${PV}")
	fi
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/systemd-cron/${PN}/archive/v${PV}.tar.gz -> systemd-cron-${PV}.tar.gz"
fi
LICENSE="MIT"
SLOT="0"
IUSE="cron-boot etc-crontab-systemd minutely setgid yearly"

DEPEND="sys-process/cronbase"
RDEPEND="
	${DEPEND}
	>=sys-apps/systemd-217
	sys-apps/debianutils
	!etc-crontab-systemd? ( !sys-process/dcron )
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	python_fix_shebang --force "${S}/src/bin"

	if use etc-crontab-systemd; then
		sed -i \
			-e 's/^crontab/crontab-systemd/' \
			-e 's/^CRONTAB/CRONTAB-SYSTEMD/' \
			-- "${S}/src/man/crontab."{1,5}".in" || die

		sed -i \
			-e 's!/crontab$!/crontab-systemd!' \
			-e 's!/crontab\(\.[15]\)$!/crontab-systemd\1!' \
			-- "${S}/Makefile.in" || die

		sed -i \
			-e "s!/etc/crontab!/etc/crontab-systemd!" \
			-- "${S}/src/man/crontab."{1,5}".in" \
			"${S}/src/bin/systemd-crontab-generator.py" || die
	fi

	default
}

my_use_enable() {
	if use ${1}; then
		echo --enable-${2:-${1}}=yes
	else
		echo --enable-${2:-${1}}=no
	fi
}

src_configure() {
	local myeconfargs=(
		--prefix="${EPREFIX}/usr"
		--confdir="${EPREFIX}/etc"
		--runparts="${EPREFIX}/bin/run-parts"
		--mandir="${EPREFIX}/usr/share/man"
		--unitdir="$(systemd_get_systemunitdir)"
		--statedir="${EPREFIX}/var/spool/cron/crontabs"
		$(my_use_enable cron-boot boot)
		$(my_use_enable minutely)
		$(my_use_enable yearly)
		$(my_use_enable yearly quarterly)
		$(my_use_enable yearly semi_annually)
		$(my_use_enable setgid)
		--enable-persistent=yes
	)
	./configure "${myeconfargs[@]}"
}

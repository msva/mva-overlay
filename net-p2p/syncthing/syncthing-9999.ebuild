# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base git-r3 systemd user

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="cli selinux tools"

RDEPEND="selinux? ( sec-policy/selinux-syncthing )"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

EGO_PN="github.com/${PN}/${PN}"
EGIT_REPO_URI="https://${EGO_PN}"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
EGIT_MIN_CLONE_TYPE="single+tags"
S="${EGIT_CHECKOUT_DIR}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "/var/lib/${PN}" "${PN}"

	if use tools ; then
		# separate user for the relay server
		enewgroup strelaysrv
		enewuser strelaysrv -1 -1 /var/lib/strelaysrv strelaysrv
		# and his home folder
		keepdir /var/lib/strelaysrv
		fowners strelaysrv:strelaysrv /var/lib/strelaysrv
	fi
}

src_prepare() {
	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		"${S}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service" \
		|| die
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"
	local version="$(git describe --always)"

	go run build.go -version "${version}" -no-upgrade install \
		$(usex tools "all" "") || die "build failed"

	if ! use tools && use cli; then
		go build -o bin/stcli ./cmd/stcli
	fi
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	doman man/*.[0-9]

	dobin "bin/${PN}"

	if use cli; then
		dobin bin/stcli
		dosym stcli "/usr/bin/${PN}-cli"
	fi

	if use tools ; then
		exeinto "/usr/libexec/${PN}"
		for f in $(find bin -type f -not -name syncthing -and -not -name stcli); do
			doexe "${f}"
		done
	fi

	einstalldocs

	systemd_dounit "${S}/etc/linux-systemd/system/${PN}"{@,-resume}.service
	systemd_douserunit "${S}/etc/linux-systemd/user/${PN}".service

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir /var/{lib,log}/"${PN}"
	fowners "${PN}:${PN}" /var/{lib,log}/"${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	if use tools ; then
		systemd_dounit "${S}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service"
		newconfd "${FILESDIR}/strelaysrv.confd" strelaysrv
		newinitd "${FILESDIR}/strelaysrv.initd" strelaysrv

		insinto /etc/logrotate.d
		newins "${FILESDIR}/strelaysrv.logrotate" strelaysrv
	fi

	default
}

pkg_postinst() {
	# check if user syncthing-relaysrv exists
	# if yes, warn that it has been moved to strelaysrv
	if [[ -n "$(egetent passwd syncthing-relaysrv 2>/dev/null)" ]]; then
		ewarn
		ewarn "The user and group for the relay server have been changed"
		ewarn "from syncthing-relaysrv to strelaysrv"
		ewarn "The old user and group are not deleted automatically. Delete them by running:"
		ewarn "	userdel -r syncthing-relaysrv"
		ewarn "	groupdel syncthing-relaysrv"
	fi

	elog "If you want to run Syncthing for more than one user, you can:"
	elog
	elog "In case you're using OpenRC:"
	elog "Create a symlink to the syncthing init script called"
	elog "syncthing.<username> - like so:"
	elog "\t# ln -s syncthing /etc/init.d/syncthing.johndoe"
	elog "and start/rc-update it instead of 'standard' one"
	elog
	elog "In case you're using SystemD:"
	elog "Just start (and 'enable', for autostarting) service like:"
	elog "\t# systemctl start ${PN}@johndoe"
	elog "instead of 'standard' one."
}

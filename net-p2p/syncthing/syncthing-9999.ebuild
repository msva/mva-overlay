# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit desktop go-module user-info git-r3 systemd xdg-utils

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"

EGIT_REPO_URI="https://github.com/syncthing/syncthing"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
IUSE="new-gui selinux tools"

RDEPEND="
	acct-group/syncthing
	acct-user/syncthing
	tools? (
		>=acct-user/stdiscosrv-1
		>=acct-user/strelaysrv-1
	)
	selinux? ( sec-policy/selinux-syncthing )
"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.18.4-tool_users.patch
)

RESTRICT="new-gui? ( network-sandbox )"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_prepare() {
	# Bug #679280
	xdg_environment_reset

	default
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/stdiscosrv|' \
		"${S}/cmd/stdiscosrv/etc/linux-systemd/stdiscosrv.service" \
		|| die
	sed -i \
		's|^ExecStart=.*|ExecStart=/usr/libexec/syncthing/strelaysrv|' \
		"${S}/cmd/strelaysrv/etc/linux-systemd/strelaysrv.service" \
		|| die

	# We do not need this and it sometimes causes build failures
	rm -rf cmd/stupgrades
}

src_compile() {
	local version="$(git describe --always)"

	GOARCH= ego run build.go -version "v${version##v}" -no-upgrade -build-out=bin/ \
		$(usex new-gui "--with-next-gen-gui" "") \
		${GOARCH:+-goarch="${GOARCH}"} \
		install $(usex tools "all" "")
}

src_test() {
	ego run build.go test
}

src_install() {
	doman man/*.[0-9]

	dobin "bin/${PN}"
	domenu etc/linux-desktop/*.desktop
	for icon_size in 32 64 128 256 512; do
		newicon -s ${icon_size} assets/logo-${icon_size}.png ${PN}.png
	done
	newicon -s scalable assets/logo-only.svg ${PN}.svg

	if use tools ; then
		exeinto "/usr/libexec/${PN}"
		for f in $(find bin -type f -not -name syncthing); do
			doexe "${f}"
		done
	fi

	einstalldocs

	systemd_dounit "etc/linux-systemd/system/${PN}"{@,-resume}.service
	systemd_douserunit "etc/linux-systemd/user/${PN}".service

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir /var/{lib,log}/"${PN}"
	# fowners "${PN}:${PN}" /var/{lib,log}/"${PN}"
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

	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}

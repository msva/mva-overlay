# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

PYTHON_COMPAT=(python3_{12..15} pypy3{,_11} )
PYTHON_REQ_USE="tk"
inherit python-r1 wrapper desktop

MY_PN="RNode_Halow_OTA_Flasher"
DESCRIPTION="GUI updater for RNode-HaLow devices"
HOMEPAGE="https://github.com/I-AM-ENGINEER/RNode_Halow_OTA_Flasher"
SRC_URI="https://github.com/I-AM-ENGINEER/${MY_PN}/archive/${PV+v}${MY_SHA:-${PV}}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${MY_SHA:-${PV}}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="utils"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/tftpy
	net-analyzer/scapy
	sys-auth/polkit
	utils? ( net-libs/libpcap )
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	# NOTE: package is not compatible with normal packaging, so goes to /opt.
	# TODO: But maybe I'll try to make it normal way someday

	insinto "/opt/${PN}"
	doins -r modules embedded_fw *py

	magick "${S}/rns.ico" "${T}/${PN}.png" || die
	doicon "${T}/${PN}.png"

	echo '#!/bin/sh
	exec pkexec --keep-cwd env \
	DISPLAY=${DISPLAY} \
	WAYLAND_DISPLAY=${WAYLAND_DISPLAY} \
	XDG_SESSION_TYPE=${XDG_SESSION_TYPE} \
	XAUTHORITY=${XAUTHORITY} \
	SCAPY_USE_LIBPCAP=${SCAPY_USE_LIBPCAP} \
	${PYTHON:-python} ${*}
	' > "${EPREFIX}/${D}/opt/${PN}/pke-py-wrapper"
	fperms +x "/opt/${PN}/pke-py-wrapper"

	make_wrapper "${PN}" "./pke-py-wrapper ./rnode-halow-flasher-gui.py" "/opt/${PN}"
	if use utils; then
		make_wrapper "rnode-halow-utils" \
			"SCAPY_USE_LIBPCAP=yes ./pke-py-wrapper ./rnode-halow-utils.py" \
			"/opt/${PN}"
	fi

	make_desktop_entry "${PN}" "${PN}" "${PN}" "Qt;KDE;Network" || die

	# TODO:
	#
	# python_foreach_impl python_newscript "${S}/rnode-halow-flasher-gui.py" "rnode-halow-flasher-gui"
	# python_foreach_impl python_newscript "${S}/rnode-halow-utils.py" "rnode-halow-utils"

	default
}

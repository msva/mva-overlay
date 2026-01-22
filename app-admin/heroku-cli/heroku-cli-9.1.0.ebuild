# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

MY_PN="${PN/-cli}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A tool for creating and managing Heroku apps from the command line"
HOMEPAGE="https://devcenter.heroku.com/articles/heroku-cli"
SRC_URI="https://registry.npmjs.org/${MY_PN}/-/${MY_P}.tgz -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="network-sandbox strip"

RDEPEND="dev-vcs/git"
BDEPEND="net-libs/nodejs[npm]"

src_install() {
	npm install -g --user root --prefix "${D}/usr" "${DISTDIR}/${A}" || die
}

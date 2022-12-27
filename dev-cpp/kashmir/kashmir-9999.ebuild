# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Library is provide functionality that not present in the C++ standard library."
HOMEPAGE="https://github.com/Corvusoft/kashmir-dependency"
EGIT_REPO_URI="https://github.com/Corvusoft/${PN}-dependency.git"

LICENSE="Boost-1.0"
SLOT="0"

src_install() {
	insinto "/usr/include/${PN}"
	doins ${PN}/*.h

	insinto "/usr/include/${PN}/system"
	doins ${PN}/system/*.h
}

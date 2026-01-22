# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

PYTHON_COMPAT=( python3_{8..14} python3_13t )

DISTUTILS_USE_PEP517="setuptools"

inherit git-r3 distutils-r1

DESCRIPTION="JFFS2 filesystem extraction tool"
HOMEPAGE="https://github.com/sviehb/jefferson"
EGIT_REPO_URI="https://github.com/sviehb/jefferson"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-python/cstruct"
RDEPEND="${DEPEND}"

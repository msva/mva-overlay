# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake git-r3

DESCRIPTION="Tools that let you decrypt, extract, and repack PS Vita CMA backup images"
HOMEPAGE="https://github.com/yifanlu/psvimgtools"
EGIT_REPO_URI="https://github.com/yifanlu/psvimgtools.git"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-libs/libgcrypt"
RDEPEND="${DEPEND}"

# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

PYTHON_COMPAT=( python3_{8..14} python3_13t pypy3{,_11} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 git-r3

DESCRIPTION="CLI interface for AWS"
HOMEPAGE="https://github.com/aws/aws-cli"

EGIT_REPO_URI="https://github.com/aws/aws-cli"
EGIT_BRANCH="develop"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="!!app-admin/awscli-bin"

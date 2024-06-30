# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..13} pypy3 )

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

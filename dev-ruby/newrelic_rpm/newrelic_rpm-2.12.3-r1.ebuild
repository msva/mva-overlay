# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

# There is no longer a Rakefile to aid in document generation.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

# Tests fail to run at all, needs investigation.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRAINSTALL="cert recipes ui newrelic.yml"

inherit ruby-fakegem

DESCRIPTION="New Relic RPM is a Ruby performance management system."
HOMEPAGE="http://www.newrelic.com"
LICENSE="Ruby"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

RUBY_PATCHES=( "${PN}-2.10.8-no-webrick.patch" "${P}-less-stdout.patch" )

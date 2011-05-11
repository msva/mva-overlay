# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Add Kerberos (password-less) authentication capabilities to Net::SSH."
HOMEPAGE="http://github.com/joekhoobyar/net-ssh-kerberos/tree/"
LICENSE="GPL-2"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
USE_RUBY="ruby18"

# Documentation uses hanna, but hanna is broken with newer versions of
# RDoc.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This library aids one in handling money and different currencies."
HOMEPAGE="http://money.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~ia64 ~x86"
SLOT="0"
IUSE=""

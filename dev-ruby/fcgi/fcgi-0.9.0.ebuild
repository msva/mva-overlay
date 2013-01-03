# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fcgi/fcgi-0.8.8-r2.ebuild,v 1.3 2012/10/28 17:51:44 armin76 Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_S="ruby-fcgi-*"

RUBY_FAKEGEM_EXTRADOC="README README.signals ChangeLog"

inherit multilib ruby-fakegem

DESCRIPTION="FastCGI library for Ruby"
HOMEPAGE="http://rubyforge.org/projects/fcgi/"
SRC_URI="https://github.com/alphallc/ruby-fcgi/archive/${PV}.tar.gz"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
LICENSE="Ruby"

DEPEND+=" dev-libs/fcgi"
RDEPEND+=" dev-libs/fcgi"

IUSE=""
SLOT="0"

each_ruby_configure() {
	case ${RUBY} in
		*ruby18|*ruby19|*rubyee18)
			${RUBY} -C ext/fcgi extconf.rb || die "extconf failed"
			;;
	esac
}

each_ruby_compile() {
	case ${RUBY} in
		*ruby18|*ruby19|*rubyee18)
			emake -C ext/fcgi
			cp ext/fcgi/fcgi$(get_modname) lib || die
			;;
	esac
}

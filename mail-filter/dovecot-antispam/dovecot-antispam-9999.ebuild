# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dovecot-antispam/dovecot-antispam-20080424.ebuild,v 1.1 2008/04/24 11:46:40 hollow Exp $

inherit confutils eutils autotools flag-o-matic git multilib

EGIT_REPO_URI="http://git.sipsolutions.net/dovecot-antispam.git"

DESCRIPTION="A dovecot antispam plugin supporting multiple backends"
HOMEPAGE="http://johannes.sipsolutions.net/Projects/dovecot-antispam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dspam crm114 mailtrain signature-log syslog"

DEPEND="net-mail/dovecot
	dspam? ( mail-filter/dspam )
	crm114? ( app-text/crm114 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

# we need this to prevent errors from dovecot-config
top_builddir() {
	return
}

pkg_setup() {
	confutils_require_one dspam signature-log mailtrain crm114
	confutils_use_depend_all syslog debug
}

src_unpack() {
	git_src_unpack
	cd "${S}"
	sed -e 's/$(INSTALLDIR)/$(DESTDIR)$(INSTALLDIR)/' -i Makefile
}

src_compile() {
	source "${ROOT}"/usr/lib/dovecot/dovecot-config || \
		die "cannot find dovecot-config"

	echo DOVECOT=${dovecot_incdir} > .config
	if has_version '=net-mail/dovecot-1.0*'; then
		echo DOVECOT_VERSION=1.0 >> .config
	elif has_version '=net-mail/dovecot-1.1*'; then
		echo DOVECOT_VERSION=1.1 >> .config
	fi
	echo INSTALLDIR=${moduledir}/imap/ >> .config
	echo PLUGINNAME=antispam >> .config
	echo USER=root >> .config
	echo GROUP=root >> .config

	use dspam && echo BACKEND=dspam-exec >> .config
	use signature-log && echo BACKEND=signature-log >> .config
	use mailtrain && echo BACKEND=mailtrain >> .config
	use crm114 && echo BACKEND=crm114-exec >> .config

	if use debug; then
		echo CFLAGS+=-g3 >> .config
		if use syslog; then
			echo DEBUG=syslog >> .config
		else
			echo DEBUG=stderr >> .config
		fi
	fi

	emake || die "make failed"
}

src_install() {
	source "${ROOT}"/usr/lib/dovecot/dovecot-config || \
		die "cannot find dovecot-config"

	dodir "${moduledir}"/imap/
	make DESTDIR="${D}" install || die "make install failed"

	newman antispam.7 dovecot-antispam.7
}

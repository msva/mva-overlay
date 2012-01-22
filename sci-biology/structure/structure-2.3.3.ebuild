# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# sci-biology/structure

EAPI="2"
inherit eutils


DESCRIPTION="A free software package for using multi-locus genotype data to investigate population structure"
HOMEPAGE="http://pritch.bsd.uchicago.edu/structure.html"
SRC_URI="http://pritch.bsd.uchicago.edu/structure_software/release_versions/v${PV}/structure_kernel_source.tar.gz
	java? ( http://pritch.bsd.uchicago.edu/structure_software/release_versions/v${PV}/structure_frontend_source.tar.gz )
	doc? ( http://pritch.bsd.uchicago.edu/structure_software/release_versions/v${PV}/structure_doc.pdf )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
RESTRICT="mirror"

IUSE="java doc"
RDEPEND="java? ( virtual/jre )"
DEPEND=""


S="${WORKDIR}/structure_kernel_src"

src_unpack() {
	# Ignore PDF file in archive list
	unpack ${A/structure_doc.pdf/}
}

src_prepare() {
	# Version 2.3.3 has old "2.3.2.1" version string
	sed -i 's/2.3.2.1 (Oct 2009)/2.3.3 (Jan 2010)/' structure.c || die "sed failed!"
	# Fix Makefile to respect env variables
	sed -i \
		-e 's/$(OPT) //g' \
		-e 's/CC =/CC ?=/' \
		-e 's/= -Wall/+=/' \
		Makefile
}

src_install() {

	# There's no install target, but only one executable, so...
	dobin structure

	# Install default parameter files under /usr/share/
	insinto /usr/share/${P}
	doins mainparams extraparams

	# Install docs
	use doc && dodoc "${DISTDIR}/structure_doc.pdf"
	
	einfo "Structure expects files mainparams and extraparams to be in the cwd at runtime."
	einfo "Defaults of these files are located under /usr/share/${P} and are a"
	einfo "good place to start."
}


# To do: Write the +java frontend portion (wow, that's alot of files)
#	- The only necessary file is Structure.jar (!) which can be put under /usr/share/structure/*
# See the binary release for a better idea of what files are necessary & how to install them.

# A simple man page might be nice, certainly easier to read than the rather obtuse pdf docs.


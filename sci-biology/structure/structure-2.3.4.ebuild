# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Package for using multi-locus genotype data to investigate population structure"
HOMEPAGE="http://pritchardlab.stanford.edu/structure.html"
SRC_URI="
	http://web.stanford.edu/group/pritchardlab/${PN}_software/release_versions/v${PV}/${PN}_kernel_source.tar.gz -> ${PN}_kernel_source-${PV}.tar.gz
	java? ( http://web.stanford.edu/group/pritchardlab/${PN}_software/release_versions/v${PV}/${PN}_frontend_source.tar.gz -> ${PN}_frontend_source-${PV}.tar.gz )
	doc? ( http://web.stanford.edu/group/pritchardlab/${PN}_software/release_versions/v${PV}/${PN}_doc.pdf -> ${PN}_doc-${PV}.pdf )
"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
RESTRICT="mirror"

IUSE="java doc"
RDEPEND="java? ( virtual/jre )"

S="${WORKDIR}/structure_kernel_src"

src_unpack() {
	# Ignore PDF file in archive list
	unpack ${A/${PN}_doc-${PV}.pdf/}
}

src_prepare() {
	# Fix Makefile to respect env variables
	sed -i \
		-e 's/$(OPT) //g' \
		-e 's/CC =/CC ?=/' \
		-e 's/= -Wall/+=/' \
		Makefile
	default
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

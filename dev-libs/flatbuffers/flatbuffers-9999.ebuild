# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 flag-o-matic java-pkg-opt-2

DESCRIPTION="Memory Efficient Serialization Library"
HOMEPAGE="https://flatbuffers.dev/"
EGIT_REPO_URI="https://github.com/google/flatbuffers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc examples java"

RDEPEND="
	java? ( virtual/jdk:* )
"
DEPEND="
	${RDEPEND}
"

DOCS=(docs)

src_prepare() {
	cmake_src_prepare
	append-cxxflags '-std=c++11'
	default
}

src_compile() {
	cmake_src_compile

	if use java ; then
	   (cd java && \
		javac com/google/flatbuffers/*.java && \
		jar cf flatbuffers.jar com/google/flatbuffers/*.class)
	fi
}

src_install() {
	cmake_src_install
	default

	insinto /usr/include
	doins -r include/flatbuffers

	if use examples ; then
		dodoc -r samples
	fi

	if use java ; then
	   insinto /usr/share/${PN}
	   doins java/flatbuffers.jar
	fi
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit java-pkg-2

DESCRIPTION="LSP language server for LanguageTool supporting LaTeX, Markdown, and others"
HOMEPAGE="https://valentjn.github.io/ltex/"
SRC_URI="https://github.com/valentjn/ltex-ls/releases/download/${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="
	dev-java/slf4j-api:0
	dev-java/slf4j-nop:0
	dev-java/guava:0
	dev-java/icu4j:0
	dev-java/jansi:2
	dev-java/commons-lang:3.6
	dev-java/commons-logging:0
	dev-java/commons-text:0
	dev-java/jackson-core:0
	dev-java/jackson-annotations:2
	dev-java/jackson-databind:0
	dev-java/jaxb-api:2
	dev-java/jaxb-runtime:4
	dev-java/picocli:0
	dev-java/protobuf-java:0
	dev-java/stax2-api:0
	dev-java/woodstox-core:0
	dev-java/json:0
	dev-java/j2objc-annotations:0
	dev-java/istack-commons-runtime:0
	dev-java/hamcrest-core:1.3
	dev-java/failureaccess:0
	dev-java/error-prone-annotations:0
	dev-java/checker-framework-qual:0
	dev-java/animal-sniffer-annotations:0
	dev-java/fastinfoset:0
"

RDEPEND="
	>=virtual/jre-1.8
	${CP_DEPEND}
"

src_prepare() {
	default

	rm lib/{slf4j,guava,icu4j,junit,hamcrest-core,FastInfoset,animal-sniffer-annotations}*.jar || die
	# rm lib/jansi*.jar || die # somewhy removing it causes ltex-ls to stop produce colors/boldness ascii-sequences
	rm lib/checker-qual-*.jar || die # may cuse breakages. Needs testing.
	rm lib/{commons-{lang3,text,logging},error_prone_annotations,failureaccess,istack-commons-runtime}*.jar || die
	rm lib/{j2objc-annotations,jackson,jaxb-api,json,picocli,protobuf-java,stax2-api,woodstox-core}*.jar || die

	mv lib/"${P/x-l/xl}".jar lib/"${PN}".jar || die

	java-pkg-2_src_prepare
}

src_compile() { :; }

_gen-cp() {
	debug-print-function ${FUNCNAME} "${@}"

	local atom
	local pat="/(([[:alnum:]+_-]+)-[0-9]+(\.[0-9]+)*[a-z]?(_[[:alnum:]]+)*(-r[0-9]*)?|[[:alnum:]+_-]+):([[:alnum:]+_.-]+)"
	for atom in ${CP_DEPEND}; do
		if [[ ${atom} =~ ${pat} ]]; then
			atom=${BASH_REMATCH[2]:-${BASH_REMATCH[1]}}
			[[ ${BASH_REMATCH[6]} != 0 ]] && atom+=-${BASH_REMATCH[6]}
			local regex="(^|\s|,)${atom}($|\s|,)"
			[[ ${!1} =~ ${regex} ]] || declare -g ${1}+=${!1:+,}${atom}
		else
			die "Invalid CP_DEPEND atom ${atom}, ensure a SLOT is included"
		fi
	done
}

src_install() {
	java-pkg_dojar lib/*.jar

	java-pkg_dolauncher ${PN} --main org.bsplines.ltexls.LtexLanguageServerLauncher
	# java-pkg_dolauncher ${PN}-cli --main org.bsplines.lspcli.LspCliLauncher
	# TODO: integrate with json from bin/

	dodoc ACKNOWLEDGMENTS.md README.md

	unset MY_DEPEND
	_gen-cp MY_DEPEND
	java-pkg_register-dependency "${MY_DEPEND}"
}

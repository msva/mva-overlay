# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"
inherit eutils

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns (data)"
HOMEPAGE="http://2gis.ru"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/unzip"
RDEPEND=">=app-misc/2gis-3.12.0.2"

IUSE=""
SRC_URI=""

S="${WORKDIR}"

my_add_town() {
	local town="${1}"
	local useflag="${1,,}"
	local postfix="${4}"
	local d_year="10#${2}"
	local d_mon="10#${3}"
	local p_year="10#${PV:0:4}"
	local p_mon="10#${PV:4:2}"
	local rev=$((12*p_year+p_mon-12*d_year-d_mon))
	SRC_URI="${SRC_URI} ${useflag}? ( http://download.2gis.ru/arhives/2GISData_${town}${postfix}-${rev}.orig.zip )"
	IUSE="${IUSE} ${useflag}"
}

# 20yy mm is the date of revision _0_.
my_add_town Abakan 2012 6
my_add_town Almaty 2012 4
my_add_town Arkhangelsk 2011 8
my_add_town Astrakhan 2005 11
my_add_town Barnaul 2005 2
my_add_town Belgorod 2011 6
my_add_town Biysk 2008 10
my_add_town Blagoveshensk 2011 9
my_add_town Bratsk 2011 9
my_add_town Bryansk 2012 2
my_add_town Cheboksary 2011 10
my_add_town Chelyabinsk 2007 8
my_add_town Chita 2012 4
my_add_town Donetsk 2012 12
my_add_town Ekaterinburg 2005 12
my_add_town Gornoaltaysk 2010 4
my_add_town Irkutsk 2006 4
my_add_town Ivanovo 2012 4
my_add_town Izhevsk 2011 3
my_add_town Kaliningrad 2011 2
my_add_town Kaluga 2012 2
my_add_town Karaganda 2013 3
my_add_town Kazan 2008 11
my_add_town Kemerovo 2005 4
my_add_town Kirov 2012 1
my_add_town Khabarovsk 2010 11
my_add_town Kostroma 2010 10
my_add_town Komsomolsk 2013 7
my_add_town Krasnodar 2010 1
my_add_town Krasnoyarsk 2005 8
my_add_town Kurgan 2006 3
my_add_town Kursk 2012 5
my_add_town Lenkuz 2013 1
my_add_town Lipetsk 2011 11
my_add_town Limassol 2013 6 "_en"
my_add_town Magnitogorsk 2010 4
my_add_town Miass 2013 2
my_add_town Minvody 2013 4
my_add_town Moscow 2011 4
my_add_town Nabchelny 2010 6
my_add_town Nahodka 2013 2
my_add_town Novokuznetsk 2005 8
my_add_town N_Novgorod 2008 9
my_add_town Novorossiysk 2012 5
my_add_town Novosibirsk 1998 9
my_add_town Norilsk 2012 8
my_add_town Ntagil 2011 6
my_add_town Nizhnevartovsk 2006 5
my_add_town Odessa 2007 2
my_add_town Omsk 2004 8
my_add_town Orel 2012 11
my_add_town Orenburg 2011 7
my_add_town Padova 2012 4 "_it"
my_add_town Penza 2011 4
my_add_town Perm 2007 12
my_add_town Petrozavodsk 2012 10
my_add_town Praha 2013 10 "_cs"
my_add_town Pskov 2013 4
my_add_town Rostov 2010 3
my_add_town Ryazan 2011 4
my_add_town Samara 2008 7
my_add_town Saransk 2013 1
my_add_town Saratov 2011 4
my_add_town Smolensk 2012 6
my_add_town Sochi 2010 7
my_add_town Stavropol 2011 12
my_add_town Staroskol 2012 2
my_add_town Sterlitamak 2011 11
my_add_town Spb 2011 2
my_add_town Surgut 2011 2
my_add_town Syktyvkar 2012 3
my_add_town Tambov 2013 1
my_add_town Tobolsk 2013 6
my_add_town Togliatti 2008 7
my_add_town Tomsk 2004 12
my_add_town Tula 2010 11
my_add_town Tver 2011 7
my_add_town Tyumen 2006 11
my_add_town Ufa 2008 3
my_add_town Ulanude 2011 1
my_add_town Ulyanovsk 2011 11
my_add_town Ussuriysk 2013 2
my_add_town Ustkam 2013 5
my_add_town Vladivostok 2010 3
my_add_town V_Novgorod 2012 7
my_add_town Vladimir 2012 2
my_add_town Volgograd 2010 9
my_add_town Vologda 2012 7
my_add_town Voronezh 2010 7
my_add_town Yaroslavl 2010 6
my_add_town Yakutsk 2011 8
my_add_town Yoshkarola 2012 4
my_add_town Yuzhnosakhalinsk 2013 2

src_prepare() {
	mv "${WORKDIR}"/2gis "${S}"
	default
}

src_install() {
	insinto /opt/2gis
	# Only attempt to install any data if the user has enabled at least
	# one useflag.
	if [ -d 2gis/3.0 ]; then
		# Only required data files were unpacked, so it should be safe
		# to use wildcard.
		doins -r 2gis/3.0/* || die
	fi
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"
inherit eutils versionator

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns (data)"
HOMEPAGE="http://2gis.ru"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/unzip"
RDEPEND=">=app-misc/2gis-3.0.7.1"

IUSE="venezia"
SRC_URI="venezia? ( http://download.2gis.com/arhives/2GISData_Padova~it-6.0.0.zip )"

S="${WORKDIR}"

MY_PV_YEAR=$(get_version_component_range 1)
MY_PV_MON=$(get_version_component_range 2)

my_add_town() {
	local useflag=$1
	local town=$2
	local year=$3
	local mon=$4
	local rev=$(( 12*${MY_PV_YEAR} + ${MY_PV_MON} - 12*${year} - ${mon} ))
	SRC_URI="${SRC_URI} ${useflag}? ( http://download.2gis.ru/arhives/2GISData_${town}-${rev}.orig.zip )"
	IUSE="${IUSE} ${useflag}"
}

# 20yy mm is the date of revision _0_.
my_add_town abakan Abakan 2012 6
my_add_town almaty Almaty 2012 4
my_add_town arkhangelsk Arkhangelsk 2011 8
my_add_town astrakhan Astrakhan 2005 11
my_add_town barnaul Barnaul 2005 2
my_add_town belgorod Belgorod 2011 6
my_add_town biysk Biysk 2008 10
my_add_town blagoveshensk Blagoveshensk 2011 9
my_add_town bratsk Bratsk 2011 9
my_add_town bryansk Bryansk 2012 2
my_add_town cheboksary Cheboksary 2011 10
my_add_town chelyabinsk Chelyabinsk 2007 8
my_add_town chita Chita 2012 4
my_add_town ekaterinburg Ekaterinburg 2005 12
my_add_town gornoaltaysk Gornoaltaysk 2010 4
my_add_town irkutsk Irkutsk 2006 4
my_add_town ivanovo Ivanovo 2012 4
my_add_town izhevsk Izhevsk 2011 3
my_add_town kaliningrad Kaliningrad 2011 2
my_add_town kaluga Kaluga 2012 2
my_add_town kazan Kazan 2008 11
my_add_town kemerovo Kemerovo 2005 4
my_add_town kirov Kirov 2012 1
my_add_town khabarovsk Khabarovsk 2010 11
my_add_town kostroma Kostroma 2010 10
my_add_town krasnodar Krasnodar 2010 1
my_add_town krasnoyarsk Krasnoyarsk 2005 8
my_add_town kurgan Kurgan 2006 3
my_add_town kursk Kursk 2012 5
my_add_town lipetsk Lipetsk 2011 11
my_add_town magnitogorsk Magnitogorsk 2010 4
my_add_town moscow Moscow 2011 4
my_add_town nabchelny Nabchelny 2010 6
my_add_town novokuznetsk Novokuznetsk 2005 8
my_add_town n_novgorod N_Novgorod 2008 9
my_add_town novorossiysk Novorossiysk 2012 5
my_add_town novosibirsk Novosibirsk 1998 9
my_add_town norilsk Norilsk 2012 8
my_add_town ntagil Ntagil 2011 6
my_add_town nizhnevartovsk Nizhnevartovsk 2006 5
my_add_town odessa Odessa 2007 2
my_add_town omsk Omsk 2004 8
#my_add_town orel Orel 2012 11 #TBD after release in 2012.11
my_add_town orenburg Orenburg 2011 7
my_add_town penza Penza 2011 4
my_add_town perm Perm 2007 12
my_add_town rostov Rostov 2010 3
my_add_town ryazan Ryazan 2011 4
my_add_town samara Samara 2008 7
my_add_town saratov Saratov 2011 4
my_add_town smolensk Smolensk 2012 6
my_add_town sochi Sochi 2010 7
my_add_town stavropol Stavropol 2011 12
my_add_town staroskol Staroskol 2012 2
my_add_town sterlitamak Sterlitamak 2011 11
my_add_town spb Spb 2011 2
my_add_town surgut Surgut 2011 2
my_add_town syktyvkar Syktyvkar 2012 3
my_add_town tver Tver 2011 7
my_add_town tyumen Tyumen 2006 11
my_add_town togliatti Togliatti 2008 7
my_add_town tomsk Tomsk 2004 12
my_add_town tula Tula 2010 11
my_add_town vladivostok Vladivostok 2010 3
my_add_town v_novgorod V_Novgorod 2012 7
my_add_town vladimir Vladimir 2012 2
my_add_town volgograd Volgograd 2010 9
my_add_town vologda Vologda 2012 7
my_add_town voronezh Voronezh 2010 7
my_add_town ufa Ufa 2008 3
my_add_town ulanude Ulanude 2011 1
my_add_town ulianovsk Ulyanovsk 2011 11
my_add_town yaroslavl Yaroslavl 2010 6
my_add_town yakutsk Yakutsk 2011 8
my_add_town yoshkarola Yoshkarola 2012 4

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

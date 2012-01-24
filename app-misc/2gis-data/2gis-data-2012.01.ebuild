# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils versionator

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns (data)"
HOMEPAGE="http://2gis.ru"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/unzip"
RDEPEND=">=app-misc/2gis-3.0.7.1"

IUSE=""
SRC_URI=""
RESTRICT="mirror"

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
my_add_town arkh Arkhangelsk 2011 8
my_add_town astr Astrakhan 2005 11
my_add_town belg Belgorod 2011 6
my_add_town barn Barnaul 2005 2
my_add_town biysk Biysk 2008 10
my_add_town brat Bratsk 2011 9
my_add_town cheb Cheboksary 2011 10
my_add_town chel Chelyabinsk 2007 8
my_add_town ekb Ekaterinburg 2005 12
my_add_town galt Gornoaltaysk 2010 4
my_add_town irk Irkutsk 2006 4
my_add_town izh Izhevsk 2011 3
my_add_town kal Kaliningrad 2011 2
my_add_town kaz Kazan 2008 11
my_add_town kdar Krasnodar 2010 1
my_add_town kem Kemerovo 2005 4
#my_add_town kir Kirov #TOBE in Jan 2012 (?)
my_add_town khb Khabarovsk 2010 11
my_add_town kost Kostroma 2010 10
my_add_town kras Krasnoyarsk 2005 8
my_add_town kur Kurgan 2006 3
my_add_town lip Lipetsk 2011 11
my_add_town magn Magnitogorsk 2010 4
my_add_town msk Moscow 2011 4
my_add_town nchl Nabchelny 2010 6
my_add_town nkuz Novokuznetsk 2005 8
my_add_town nnov N_Novgorod 2008 9
my_add_town nsk Novosibirsk 1998 9
my_add_town ntag Ntagil 2011 6
my_add_town nvar Nizhnevartovsk 2006 5
my_add_town odes Odessa 2007 2
my_add_town omsk Omsk 2004 8
my_add_town oren Orenburg 2011 7
my_add_town penza Penza 2011 4
my_add_town perm Perm 2007 12
my_add_town rost Rostov 2010 3
my_add_town ryaz Ryazan 2011 4
my_add_town sam Samara 2008 7
my_add_town sar Saratov 2011 4
#my_add_town smol Smolensk #TOBE in Mar 2012
my_add_town stav Stavropol 2011 12
my_add_town sochi Sochi 2010 7
my_add_town ster Sterlitamak 2011 11
my_add_town spb Spb 2011 2
my_add_town sur Surgut 2011 2
my_add_town tver Tver 2011 7
my_add_town tim Tyumen 2006 11
my_add_town tlt Togliatti 2008 7
my_add_town tom Tomsk 2004 12
my_add_town tula Tula 2010 11
my_add_town vlad Vladivostok 2010 3
my_add_town volg Volgograd 2010 9
my_add_town vrnz Voronezh 2010 7
my_add_town ufa Ufa 2008 3
my_add_town ulan Ulanude 2011 1
my_add_town uli Ulyanovsk 2011 11
my_add_town yar Yaroslavl 2010 6
my_add_town yak Yakutsk 2011 8

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

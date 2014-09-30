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

# RU

my_add_town Abakan				2012 6  # Абакан
my_add_town Almetevsk			2014 8  # Альметьевск
my_add_town Arkhangelsk			2011 8  # Архангельск
my_add_town Armawir				2014 3  # Армавир
my_add_town Astrakhan			2005 11 # Астрахань

my_add_town Barnaul				2005 2  # Барнаул
my_add_town Belgorod			2011 6  # Белгород
my_add_town Biysk				2008 10 # Бийск
my_add_town Blagoveshensk		2011 9  # Благовещенск
my_add_town Bratsk				2011 9  # Братск
my_add_town Bryansk				2012 2  # Брянск

my_add_town V_Novgorod			2012 7  # Великий Новгород
my_add_town Vladivostok			2010 3  # Владивосток
my_add_town Vladimir			2012 2  # Владимир
my_add_town Volgograd			2010 9  # Волгоград
my_add_town Vologda				2012 7  # Вологда
my_add_town Voronezh			2010 7  # Воронеж

my_add_town Gornoaltaysk		2010 4  # Горный Алтай

my_add_town Ekaterinburg		2005 12 # Екатеринбург

my_add_town Ivanovo				2012 4  # Иваново
my_add_town Izhevsk				2011 3  # Ижевск
my_add_town Irkutsk				2006 4  # Иркутск

my_add_town Yoshkarola			2012 4  # Йошкар-Ола

my_add_town Kazan				2008 11 # Казань
my_add_town Kaliningrad			2011 2  # Калининград
my_add_town Kaluga				2012 2  # Калуга
my_add_town Kemerovo			2005 4  # Кемерово
my_add_town Kirov				2012 1  # Киров
my_add_town Komsomolsk			2013 7  # Комсомольск-на-Амуре
my_add_town Kostroma			2010 10 # Кострома
my_add_town Krasnodar			2010 1  # Краснодар
my_add_town Krasnoyarsk			2005 8  # Красноярск
my_add_town Kurgan				2006 3  # Курган
my_add_town Kursk				2012 5  # Курск

my_add_town Lenkuz				2013 1  # Ленинск-Кузнецкий
my_add_town Lipetsk				2011 11 # Липецк

my_add_town Magnitogorsk		2010 4  # Магнитогорск
my_add_town Miass				2013 2  # Миасс
my_add_town Moscow				2011 4  # Москва
my_add_town Murmansk			2014 7  # Мурманск

my_add_town Nabchelny			2010 6  # Набережные Челны
my_add_town Nahodka				2013 2  # Находка
my_add_town Nizhnevartovsk		2006 5  # Нижневартовск
my_add_town N_Novgorod			2008 9  # Нижний Новгород
my_add_town Ntagil				2011 6  # Нижний Тагил
my_add_town Novokuznetsk		2005 8  # Новокузнецк
my_add_town Novorossiysk		2012 5  # Новороссийск
my_add_town Novosibirsk			1998 9  # Новосибирск
my_add_town Norilsk				2012 8  # Норильск
my_add_town Noyabrsk			2013 12 # Ноябрьск

my_add_town Omsk				2004 8  # Омск
my_add_town Orel				2012 10 # Орёл
my_add_town Orenburg			2011 7  # Оренбург

my_add_town Penza				2011 4  # Пенза
my_add_town Perm				2007 12 # Пермь
my_add_town Petrozavodsk		2012 10 # Петрозаводск
my_add_town P_kamchatskiy		2014 6  # Петропавловск-Камчатский
my_add_town Pskov				2013 4  # Псков
my_add_town Minvody				2013 4  # Пятигорск (КМВ)

my_add_town Rostov				2010 3  # Ростов-на-Дону
my_add_town Ryazan				2011 4  # Рязань

my_add_town Samara				2008 7  # Самара
my_add_town Spb					2011 2  # Санкт-Петербург
my_add_town Saransk				2013 1  # Саранск
my_add_town Saratov				2011 4  # Саратов
my_add_town Smolensk			2012 6  # Смоленск
my_add_town Sochi				2010 7  # Сочи
my_add_town Stavropol			2011 12 # Ставрополь
my_add_town Staroskol			2012 2  # Старый Оскол
my_add_town Sterlitamak			2011 11 # Стерлитамак
my_add_town Surgut				2011 2  # Сургут
my_add_town Syktyvkar			2012 3  # Сыктывкар

my_add_town Tambov				2013 1  # Тамбов
my_add_town Tver				2011 7  # Тверь
my_add_town Tobolsk				2013 6  # Тобольск
my_add_town Togliatti			2008 7  # Тольятти
my_add_town Tomsk				2004 12 # Томск
my_add_town Tula				2010 11 # Тула
my_add_town Tyumen				2006 11 # Тюмень

my_add_town Ulanude				2011 1  # Улан-Уде
my_add_town Ulyanovsk			2011 11 # Ульяновск
my_add_town Ussuriysk			2013 2  # Уссурийск
my_add_town Ufa					2008 3  # Уфа

my_add_town Khabarovsk			2010 11 # Хабаровск

my_add_town Cheboksary			2011 10 # Чебоксары
my_add_town Chelyabinsk			2007 8  # Челябинск
my_add_town Chita				2012 4  # Чита

my_add_town Yuzhnosakhalinsk	2013 2  # Южно-Сахалинск

my_add_town Yakutsk				2011 8  # Якутск
my_add_town Yaroslavl			2010 6  # Ярославль

# UA (Ukraine)
my_add_town Donetsk				2012 11 # Донецк
my_add_town Odessa				2007 2  # Одесса
my_add_town Dnepropetrovsk		2014 4  # Днепропетровск

# KZ (Kazakhstan)
my_add_town Almaty				2012 4  # Алматы
my_add_town Karaganda			2013 3  # Караганда
my_add_town Ustkam				2013 5  # Усть-Каменогорск

# CY (Cyprus)
my_add_town Limassol			2013 6 "_en" # Lemessos
my_add_town Nicosia				2014 1 "_en" # Lefkosia

# CZ (Czech)
my_add_town Praha				2013 10 "_cs" # Praha

# IT (Italia)
my_add_town Padova				2012 4 "_it" # Venezzia è Padova

# CL (Chile)
my_add_town Santiago			2014 3 "_es" # Santiago

# AE (UAE)
my_add_town Dubai				2014 7 "_en" # Dubai


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

prefix=/opt/cprocsp
exec_prefix=/opt/cprocsp
PATH=$PATH:/opt/cprocsp/sbin/amd64
/sbin/ldconfig -f /etc/ld.so.conf

if test -r /etc/debian_version; then
  if ! dpkg -s lsb-base > /dev/null 2>&1; then
      echo -e "Lsb-core package is needed. Execute\n\
      apt-get install lsb-base\nto install it."
  fi
fi

#Нужно проверить этот блок
if test -z "";then
    test -r /etc/debian_version && debian=1
    if test -n "$debian" && test -f /usr/sbin/update-rc.d;then
      /usr/sbin/update-rc.d cprocsp defaults
    elif test -f /usr/lib/lsb/install_initd;then
      /usr/lib/lsb/install_initd /etc/init.d/cprocsp
      if test -f /sbin/insserv && test -f /usr/bin/systemctl; then
        systemctl daemon-reload
      fi
    elif test -f /sbin/chkconfig;then
      /sbin/chkconfig --add cprocsp
    elif test -f /usr/sbin/update-rc.d; then
      /usr/sbin/update-rc.d cprocsp defaults
    else
      for i in 2 3 4 5;do
	ln -sf /etc/init.d/cprocsp /etc/rc.d/rc$i.d/S50cprocsp
      done
      for i in 0 1 6;do
	ln -sf /etc/init.d/cprocsp /etc/rc.d/rc$i.d/K60cprocsp
      done
    fi
fi

if test -z "#";then
    sysctl vfs.usermount=1
    test -c /dev/fd0 && chmod a+rw /dev/fd0
    cp /var/opt/cprocsp/tmp/cprocsp /etc/init.d/cprocsp
fi    
if test -z "" && test -d /etc/cron.daily
then
    echo '#!/bin/sh' >/etc/cron.daily/cprocsp
    echo '/etc/init.d/cprocsp check > /dev/null 2>&1' >>/etc/cron.daily/cprocsp
    chmod +x /etc/cron.daily/cprocsp
else
    crontab -l 2>/dev/null |fgrep -v '/etc/init.d/cprocsp' > /tmp/crontab.tmp
    echo '00 0,12 * * * /etc/init.d/cprocsp check > /dev/null 2>&1' >> /tmp/crontab.tmp
# echo '@reboot /etc/init.d/cprocsp start > /dev/null 2>&1' >> /tmp/crontab.tmp
    crontab /tmp/crontab.tmp
fi
# �� FreeBSD � mac OS ���� ������ ����� �� �����
if test -z "#" || test -z "#"; then
  test ! -d /var/opt/cprocsp/keys && mkdir -p /var/opt/cprocsp/keys
  chmod 1777 /var/opt/cprocsp/keys
  chmod 1777 /var/opt/cprocsp/users
  chmod 1777 /var/opt/cprocsp/tmp
  chmod 711 /var/opt/cprocsp/mnt
fi
#Проверить блок до этого места

test_command=test
#test_command=/bin/test

$test_command ! -d /usr/share/man/man8 && mkdir -p /usr/share/man/man8
$test_command ! -d /usr/share/man/ru/man8 && mkdir -p /usr/share/man/ru/man8

$test_command ! -e /usr/share/man/man8/certmgr.8 && \
$test_command ! -h /usr/share/man/man8/certmgr.8 && \
ln -sf /opt/cprocsp/share/man/man8/certmgr.8 /usr/share/man/man8/certmgr.8

$test_command ! -e /usr/share/man/ru/man8/certmgr.8 && \
$test_command ! -h /usr/share/man/ru/man8/certmgr.8 && \
ln -sf /opt/cprocsp/share/man/man8/certmgr.ru.8 /usr/share/man/ru/man8/certmgr.8

$test_command ! -e /usr/share/man/man8/stunnel.8 && \
$test_command ! -h /usr/share/man/man8/stunnel.8 && \
ln -s /opt/cprocsp/share/man/man8/stunnel.8 /usr/share/man/man8/stunnel.8

$test_command ! -e /usr/share/man/ru/man8/stunnel.8 && \
$test_command ! -h /usr/share/man/ru/man8/stunnel.8 && \
ln -s /opt/cprocsp/share/man/man8/stunnel.ru.8 /usr/share/man/ru/man8/stunnel.8

$test_command ! -e "/opt/cprocsp/share/locale/ru_RU.UTF-8" && \
$test_command ! -h "/opt/cprocsp/share/locale/ru_RU.UTF-8" && \
ln -s "/opt/cprocsp/share/locale/ru_RU.utf8" "/opt/cprocsp/share/locale/ru_RU.UTF-8"

#from scripts rpm packet lsb-cprocsp-rdr
if test -z "";then
    if ! grep -q '/opt/cprocsp/lib/amd64' /etc/ld.so.conf;then
      echo "/opt/cprocsp/lib/amd64" > /etc/ld.so.conf.d/cprocsp-lib-amd64.conf #Изменено мной
    fi
    /sbin/ldconfig -f /etc/ld.so.conf
fi

cpconfig -ini '\config\apppath' -add string libcapi10.so /opt/cprocsp/lib/amd64/libcapi10.so
cpconfig -ini '\config\apppath' -add string librdrfat12.so /opt/cprocsp/lib/amd64/librdrfat12.so
cpconfig -ini '\config\apppath' -add string librdrdsrf.so /opt/cprocsp/lib/amd64/librdrdsrf.so
cpconfig -ini '\config\apppath' -add string libcpui.so /opt/cprocsp/lib/amd64/libcpui.so

check_libcurl_compatibility() {
    command -v file > /dev/null 2>&1 || return 0
    is64arch=0
    is64arch=1
    #is64arch=1
    is64lib=0
    if test -z '' ; then
        file -L "${libcurl}" | grep '64-bit' > /dev/null 2>&1
    else
        file "${libcurl}" | grep '64-bit' > /dev/null 2>&1
    fi
    test "$?" -eq 0 && is64lib=1
    test "${is64arch}" -eq "${is64lib}" && return 0
    return 1
}
search_dirs=`echo /lib* /usr/lib* /usr/local/lib* /opt/CPcvpn-*/lib* /opt/sfw/lib* | xargs -n1 | grep -v '*' | xargs`
ld_cmd="ldconfig -p ; find ${search_dirs} -name \*libcurl\*"

libcurl_checked='manually_set_path_to_libcurl.so'
for libcurl in `eval "${ld_cmd}" | grep '/libcurl.*so' | awk '{print $NF}' | xargs` \
`eval "${ld_cmd}" | grep 'libcurl-gnutls.*so' | awk '{print $NF}' | xargs` ; do
    if check_libcurl_compatibility ; then
        libcurl_checked="${libcurl}"
        break
    fi
done
cpconfig -ini '\config\apppath' -add string libcurl.so "${libcurl_checked}"

if test -z "";then
cpconfig -ini '\config\apppath' -add string mount_flash.sh /opt/cprocsp/sbin/amd64/mount_flash.sh 
cpconfig -ini '\config\KeyDevices\FLASH' -add string DLL librdrfat12.so 
cpconfig -ini '\config\KeyDevices\FLASH' -add string Script mount_flash.sh 
cpconfig -hardware reader -add FLASH -name FLASH
fi
cpconfig -hardware rndm -add CPSD -name 'CPSD' -level 3 > /dev/null
cpconfig -ini '\config\Random\CPSD\Default' -add string '/db1/kis_1' /var/opt/cprocsp/dsrf/db1/kis_1
cpconfig -ini '\config\Random\CPSD\Default' -add string '/db2/kis_1' /var/opt/cprocsp/dsrf/db2/kis_1

cpconfig -license -view > /dev/null 2> /dev/null
test $? = 0 || cpconfig -license -set 4040E-G0037-EK8R3-C6K4U-HCXQG

#from scripts rpm packet lsb-cprocsp-kc1
cpconfig -ini '\config\apppath' -add string librdrrndmbio_tui.so /opt/cprocsp/lib/amd64/librdrrndmbio_tui.so
cpconfig -ini '\config\apppath' -add string libcsp.so /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\config\Random\Bio_tui' -add string DLL librdrrndmbio_tui.so
cpconfig -hardware reader -add hdimage -name 'HDD key storage' > /dev/null
cpconfig -hardware rndm -add bio_tui -name 'Text bio random' -level 5 > /dev/null

cpconfig -defprov -setdef -provtype 75 -provname 'Crypto-Pro GOST R 34.10-2001 KC1 CSP'
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 KC1 CSP' -add long Type 75

cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider' -add long Type 75

cpconfig -defprov -setdef -provtype 80 -provname 'Crypto-Pro GOST R 34.10-2012 KC1 CSP'
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 CSP' -add long Type 80

cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Cryptographic Service Provider' -add long Type 80

cpconfig -defprov -setdef -provtype 81 -provname 'Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP'
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 KC1 Strong CSP' -add long Type 81

cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2012 Strong Cryptographic Service Provider' -add long Type 81

cpconfig -defprov -setdef -provtype 16 -provname 'Crypto-Pro ECDSA and AES CSP'
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro ECDSA and AES CSP' -add long Type 16
cpconfig -ini '\config\parameters\Crypto-Pro ECDSA and AES CSP' -add long KeyTimeValidityControlMode 128

cpconfig -defprov -setdef -provtype 24 -provname 'Crypto-Pro Enhanced RSA and AES CSP'
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Image Path' /opt/cprocsp/lib/amd64/libcsp.so
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add string 'Function Table Name' CPCSP_GetFunctionTable
cpconfig -ini '\cryptography\Defaults\Provider\Crypto-Pro Enhanced RSA and AES CSP' -add long Type 24
cpconfig -ini '\config\parameters\Crypto-Pro Enhanced RSA and AES CSP' -add long KeyTimeValidityControlMode 128 

cpconfig -ini '\cryptography\Defaults\Provider Types\Type 075' -add string 'TypeName' "GOST R 34.10-2001 Signature with Diffie-Hellman Key Exchange"
cpconfig -ini '\cryptography\Defaults\Provider Types\Type 080' -add string 'TypeName' "GOST R 34.10-2012 (256) Signature with Diffie-Hellman Key Exchange"
cpconfig -ini '\cryptography\Defaults\Provider Types\Type 081' -add string 'TypeName' "GOST R 34.10-2012 (512) Signature with Diffie-Hellman Key Exchange"
cpconfig -ini '\cryptography\Defaults\Provider Types\Type 016' -add string 'TypeName' "ECDSA Full and AES"
cpconfig -ini '\cryptography\Defaults\Provider Types\Type 024' -add string 'TypeName' "RSA Full and AES"


#from scripts rpm packet lsb-cprocsp-capilite
cpconfig -ini '\config\apppath' -add string libcapi20.so /opt/cprocsp/lib/amd64/libcapi20.so

# create several local machine stores if they don't exist
/opt/cprocsp/bin/amd64/certmgr -list -crl -store mMy > /dev/null 2>&1
/opt/cprocsp/bin/amd64/certmgr -list -crl -store mCryptoProTrustedStore > /dev/null 2>&1

# update all stores to Windows-compatible format. we don't want to silence
# stderr because user should be notified about errors
find '/var/opt/cprocsp/users/' -name '*.sto' -type f \
    -exec /opt/cprocsp/bin/amd64/certmgr -updatestore -crl -file {} \; > /dev/null
find '/var/opt/cprocsp/users/' -name '*.sto' -type f \
    -exec /opt/cprocsp/bin/amd64/certmgr -updatestore -cert -file {} \; > /dev/null

#from script from rpm packet cprocsp-curl
if test -f "/opt/cprocsp/sbin/amd64/cpconfig"; then
    PATH=$PATH:/opt/cprocsp/sbin/amd64
    libcurl_so_backup=`cpconfig -ini '\config\apppath\libcurl.so' -view 2> /dev/null`
    status="$?"
    if test "${status}" -eq 0 ; then
        cpconfig -ini '\config\apppath\backup' -add string libcurl.so "${libcurl_so_backup}"
    fi
    cpconfig -ini '\config\apppath' -add string libcurl.so /opt/cprocsp/lib/amd64/libcpcurl.so
    #cpconfig -ini '\config\apppath' -add string libcurl.so /opt/cprocsp/lib/libcpcurl.framework/libcpcurl
fi

/sbin/ldconfig -f /etc/ld.so.conf

#from scripts rpm packet lsb-cprocsp-ca-certs

# т.к. это noarch-пакет, то зашивать путь к certmgr мы не можем, поэтому ищем его
# в macOS путь фиксирован, для остальных *nix используем * вместо жёстко заданной архитектуры
#ls_result=`ls /opt/cprocsp/bin/certmgr 2>/dev/null`
ls_result=`ls /opt/cprocsp/bin/*/certmgr 2>/dev/null`
if test $? -eq 0; then
    # ls_result может содержать более одного результата, поэтому вырезаем первый результат
    certmgr=`echo $ls_result | awk '{ print $1 }'`
    # добавление сертификатов в соответствующие хранилища. путь к файлу определяет, в какое хранилище его следует установить
    # чтобы не выводить на экран информацию из устанавливаемых сертификатов, перенаправляем стандарный вывод в /dev/null
    ls -d /var/opt/cprocsp/tmpcerts/root/* | xargs -n 1 $certmgr -install -store mroot -file 1>/dev/null || printf "Failed to install root certificates!\n"
    ls -d /var/opt/cprocsp/tmpcerts/ca/* | xargs -n 1 $certmgr -install -store mca -file 1>/dev/null || printf "Failed to install intermediate certificates!\n"
else
    printf "Warning: certmgr not found.\n"
    printf "Cannot install authorized certificates into stores.\n"
    printf "CryptoPro CAPILite package must be installed first.\n"
fi

#from scripts rpm packet cprocsp-rdr-gui-gtk
cpconfig -ini '\config\apppath' -add string librdrrndmbio_gui_fgtk.so /opt/cprocsp/lib/amd64/librdrrndmbio_gui_fgtk.so
cpconfig -ini '\config\apppath' -add string libxcpui.so /opt/cprocsp/lib/amd64/libfgcpui.so
cpconfig -ini '\config\apppath' -add string xcpui_app /opt/cprocsp/sbin/amd64/xcpui_app
cpconfig -ini '\config\Random\Bio_gui' -add string DLL librdrrndmbio_gui_fgtk.so
cpconfig -hardware rndm -add bio_gui -name 'rndm GUI gtk+2.0' -level 4 >/dev/null 2>/dev/null

#from scripts rpm packet cprocsp-rdr-pcsc
cpconfig -ini '\config\parameters' -add long dynamic_readers 1
cpconfig -ini '\config\parameters' -add long dynamic_rdr_refresh_ms 1500

# Ubunta 10: no libpcsclite.so, but have libpcsclite.so.1
cpconfig -ini '\config\apppath' -add string libpcsclite.so libpcsclite.so.1
#cpconfig -ini '\config\apppath' -add string libpcsclite.so /System/Library/Frameworks/PCSC.framework/PCSC

cpconfig -ini '\config\apppath' -add string librdrpcsc.so /opt/cprocsp/lib/amd64/librdrpcsc.so
cpconfig -ini '\config\apppath' -add string librdrric.so /opt/cprocsp/lib/amd64/librdrric.so
cpconfig -ini '\config\KeyDevices\PCSC' -add string DLL librdrpcsc.so
cpconfig -ini '\config\KeyDevices\PCSC' -add long Group 1

cpconfig -ini '\config\KeyDevices\PCSC\PNP PCSC\Default' -add string Name 'All PC/SC readers'
cpconfig -ini '\config\KeyDevices\PCSC\PNP PCSC\Default\Name' -delparam
cpconfig -ini '\config\KeyCarriers\OSCAR' -add string DLL librdrric.so
cpconfig -ini '\config\KeyCarriers\OSCAR2' -add string DLL librdrric.so
cpconfig -ini '\config\KeyCarriers\TRUST' -add string DLL librdrric.so
cpconfig -ini '\config\KeyCarriers\TRUSTS' -add string DLL librdrric.so
cpconfig -ini '\config\KeyCarriers\TRUSTD' -add string DLL librdrric.so

cpconfig -hardware media -add oscar -name 'Oscar' > /dev/null
cpconfig -hardware media -configure oscar -add hex atr 0000000000000043525950544f5052
cpconfig -hardware media -configure oscar -add hex mask 00000000000000ffffffffffffffff
cpconfig -hardware media -configure oscar -add string folders 0B00
cpconfig -hardware media -add oscar2 -name 'Oscar CSP 2.0' > /dev/null
cpconfig -hardware media -configure oscar2 -add hex atr 000000000000004350435350010102
cpconfig -hardware media -configure oscar2 -add hex mask 00000000000000ffffffffffffffff
cpconfig -hardware media -configure oscar2 -add string folders 0B00
cpconfig -hardware media -configure oscar2 -add long size_1 60
cpconfig -hardware media -configure oscar2 -add long size_2 70
cpconfig -hardware media -configure oscar2 -add long size_4 60
cpconfig -hardware media -configure oscar2 -add long size_5 70
cpconfig -hardware media -configure oscar2 -add long size_6 62
cpconfig -hardware media -add oscar2 -connect KChannel -name 'Channel K' > /dev/null
cpconfig -hardware media -configure oscar2 -connect KChannel -add hex atr 000000000000004350435350010101
cpconfig -hardware media -configure oscar2 -connect KChannel -add hex mask 00000000000000ffffffffffffffff
cpconfig -hardware media -configure oscar2 -connect KChannel -add string folders 0B00
cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_1 56
cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_2 36
cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_4 56
cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_5 36
cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_6 62

cpconfig -hardware media -add TRUST -name 'Magistra' > /dev/null
cpconfig -hardware media -configure TRUST -add hex atr 3b9e00008031c0654d4700000072f7418107
cpconfig -hardware media -configure TRUST -add hex mask ffff0000ffffffffffff300000ffffffffff
cpconfig -hardware media -configure TRUST -add string folders "A\\B\\C\\D\\E\\F\\G\\H"

cpconfig -hardware media -add TRUSTS -name 'Magistra SocCard' > /dev/null
cpconfig -hardware media -configure TRUSTS -add hex atr 3b9a00008031c0610072f7418107
cpconfig -hardware media -configure TRUSTS -add hex mask ffff0000ffffffff30ffffffffff
cpconfig -hardware media -configure TRUSTS -add string folders "A\\B\\C\\D"

cpconfig -hardware media -add TRUSTD -name 'Magistra Debug' > /dev/null
cpconfig -hardware media -configure TRUSTD -add hex atr 3b9800008031c072f7418107
cpconfig -hardware media -configure TRUSTD -add hex mask ffff0000ffffffffffffffff
cpconfig -hardware media -configure TRUSTD -add string folders "A\\B\\C\\D\\E\\F\\G\\H"


not_solaris=1
if test ! -z "$not_solaris"; then
  search_dirs=''
  for d in `echo /usr/lib*/pcsc /usr/local/lib*/pcsc /usr/libexec/SmartCardServices/*`; do
    if echo $d|grep -v '*'; then
      search_dirs="$d $search_dirs";
    fi;
  done
  if test ! -z "$search_dirs"; then
    folder=`find -L $search_dirs -name "*ccid.bundle"`
    if test ! -z "$folder"; then
      pList_files=`find -L $folder -name "Info.plist"`
      if test ! -z "$pList_files"; then
        for pList in $pList_files; do
          ccid_reg.sh -add $pList 0x072F 0x90CC "ACS ACR 38U-CCID - CP"
          ccid_reg.sh -add $pList 0x072F 0x1204 "ACS ACR101 ICC Reader - CP"
          ccid_reg.sh -add $pList 0x072F 0x8201 "ACS APG8201 PINhandy 1 - CP"
          ccid_reg.sh -add $pList 0x072F 0x8202 "ACS APG8201 USB Reader - CP"
          ccid_reg.sh -add $pList 0x072F 0x90DB "ACS CryptoMate64 - CP"
          ccid_reg.sh -add $pList 0x0483 0xACD1 "Ancud Crypton SCR/RNG - CP"
          ccid_reg.sh -add $pList 0x0A89 0x0025 "Aktiv Rutoken lite - CP"
          ccid_reg.sh -add $pList 0x0A89 0x0030 "Aktiv Rutoken ECP - CP"
          ccid_reg.sh -add $pList 0x0A89 0x0080 "Aktiv PINPad Ex - CP"
          ccid_reg.sh -add $pList 0x0A89 0x0081 "Aktiv PINPad In - CP"
          ccid_reg.sh -add $pList 0x0A89 0x0060 "Aktiv Co., ProgramPark Rutoken Magistra - CP"
          ccid_reg.sh -add $pList 0x072f 0x90de "ACS Token - CP"
          ccid_reg.sh -add $pList 0x24dc 0x0102 "ARDS ZAO JaCarta LT - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0002 "Infocrypt Token++ - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0004 "Infocrypt Token++ - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0006 "Infocrypt Token++ lite - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0008 "Infocrypt Token++ lite - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x003a "Infocrypt Token++ lite - CP"
          ccid_reg.sh -add $pList 0x2022 0x078a "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2022 0x016c "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2022 0x0172 "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2022 0x0226 "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x078a "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x016c "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0172 "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2fb0 0x0226 "Infocrypt HWDSSL DEVICE - CP"
          ccid_reg.sh -add $pList 0x2a0c 0x0001 "MultiSoft ltd. SCR2 - CP"
          ccid_reg.sh -add $pList 0x23a0 0x0008 "BIFIT ANGARA - CP"
          ccid_reg.sh -add $pList 0x1fc9 0x7479 "ISBC ESMART reader - CP"
          ccid_reg.sh -add $pList 0x2ce4 0x7479 "ESMART Token - CP"
          ccid_reg.sh -add $pList 0x04d8 0x003f "zis-group PRIVATE Security System Key"
        done
      fi
    fi
  fi
fi

#cprocsp-rdr-emv

LIBNAME=librdremv.so

cpconfig -ini '\config\apppath' -add string $LIBNAME /opt/cprocsp/lib/amd64/$LIBNAME
cpconfig -ini "\config\KeyCarriers\\GEMALTO" -add string DLL $LIBNAME

cpconfig -hardware media -add GEMALTO -name 'GEMALTO' > /dev/null
cpconfig -hardware media -configure GEMALTO -add hex atr 3b7a9400008065a20101013d72d643
cpconfig -hardware media -configure GEMALTO -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure GEMALTO -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add hex atr 3b2a008065a20102013172d643
cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add hex mask ffffffffffffffffffffffffff
cpconfig -hardware media -configure GEMALTO -connect GemSim1 -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add hex atr 3b7a9600008065a20101013d72d643
cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure GEMALTO -connect GemSim2 -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

cpconfig -hardware media -configure GEMALTO -connect Optelio -add hex atr 3b6a00008065a20101013d72d643
cpconfig -hardware media -configure GEMALTO -connect Optelio -add hex mask ffffffffffffffffffffffffffff
cpconfig -hardware media -configure GEMALTO -connect Optelio -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add hex atr 3B6E000080318066B0000000000083009000
cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add hex mask fffffffffffffffff00000000000ffffffff 
cpconfig -hardware media -configure GEMALTO -connect OptelioNDef -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

cpconfig -hardware media -configure GEMALTO -connect Native -add hex atr 3b2a008065a20101013d72d643
cpconfig -hardware media -configure GEMALTO -connect Native -add hex mask ffffffffffffffffffffffffff
cpconfig -hardware media -configure GEMALTO -connect Native -add string folders 'SLOT#01\SLOT#02\SLOT#03\SLOT#04\SLOT#05\SLOT#06'

#cprocsp-rdr-inpaspot
cd /opt/cprocsp/lib/amd64 #? Проверить необходимость

cpconfig -ini '\config\apppath' -add string librdrinpaspot.so /opt/cprocsp/lib/amd64/librdrinpaspot.so

NAME=INPASPOT
cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so

#cpconfig -hardware media -add $NAME -connect InpaspotCard -name 'Alioth Inpaspot' > /dev/null
#cpconfig -hardware media -configure $NAME -connect InpaspotCard -add hex atr  3b6e000080318066b0840c016e0183009000
#cpconfig -hardware media -configure $NAME -connect InpaspotCard -add hex mask ffffffffffffffffffffffffffffffffffff
		
cpconfig -hardware media -add $NAME -connect SCOneSeries -name 'ALIOTH, SCOne Series' > /dev/null
cpconfig -hardware media -configure $NAME -connect SCOneSeries -add hex atr  3b6d000080318065495300000183079000
cpconfig -hardware media -configure $NAME -connect SCOneSeries -add hex mask ffffffffffffffffffff0000ffffffffff

cpconfig -hardware media -add $NAME -connect SCOneV3 -name 'ALIOTH, SCOne V3' > /dev/null
cpconfig -hardware media -configure $NAME -connect SCOneV3 -add hex atr  3b6900ff4a434f503234325232
cpconfig -hardware media -configure $NAME -connect SCOneV3 -add hex mask ffffffffffffffffffffffffff

cpconfig -hardware media -add $NAME -connect J3H081 -name 'ALIOTH, SCOne J3H081' > /dev/null
cpconfig -hardware media -configure $NAME -connect J3H081 -add hex atr  3B6A00FF0031C173C84000009000
cpconfig -hardware media -configure $NAME -connect J3H081 -add hex mask ffffffffffffffffffffffffffff

cpconfig -hardware media -add $NAME -name 'ALIOTH, SCOne V4' > /dev/null
cpconfig -hardware media -configure $NAME -add hex atr  3b6800ff4a434f5076323431
cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffff

NAME=INPASPOT1
cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so
cpconfig -hardware media -add $NAME -name 'Inpaspot' > /dev/null
cpconfig -hardware media -configure $NAME -add hex atr  3bfd130000108080318065b0831100ac83009000
cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffffffffff

NAME=INPASPOT2
cpconfig -ini '\config\KeyCarriers\'$NAME -add string DLL librdrinpaspot.so
cpconfig -hardware media -add $NAME -name 'Inpaspot' > /dev/null
cpconfig -hardware media -configure $NAME -add hex atr  3bfa130000108080318066b0840c016e01
cpconfig -hardware media -configure $NAME -add hex mask ffffffffffffffffffffffffffffffffff

#cprocsp-rdr-jacarta - Это убрать если пакет со считывателями jacarta не устанавливается
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\apppath' -add string librdrjacarta.so.5.0.0 /opt/cprocsp/lib/amd64/librdrjacarta.so.5.0.0

/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_PRO16' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_PRO32' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_PRO_M420' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_PRO_M420B' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_JAVA_10' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\eToken_JAVA_10B' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\JaCarta' -add string DLL librdrjacarta.so.5.0.0
/opt/cprocsp/sbin/amd64/cpconfig -ini '\config\KeyCarriers\JaCarta_LT' -add string DLL librdrjacarta.so.5.0.0

/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_PRO16 -name 'Aladdin R.D. eToken Pro 16K' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO16 -add hex atr 3be200ffc11031fe55c8029c
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO16 -add hex mask ffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO16 -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_PRO32 -name 'Aladdin R.D. eToken Pro 32K' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO32 -add hex atr 3bf29800ffc11031fe55c80315
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO32 -add hex mask ffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO32 -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_PRO_M420 -name 'Aladdin R.D. eToken Pro M420' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420 -add hex atr 3bf2180000c10a31fe55c80600
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420 -add hex mask ffffffff00ffffffffffffff00
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420 -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_PRO_M420B -name 'Aladdin R.D. eToken Pro M420b' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420B -add hex atr 3bf2180002c10a31fe58c80975
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420B -add hex mask ffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_PRO_M420B -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_JAVA_10 -name 'Aladdin R.D. eToken Java v1.0' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10 -add hex atr 3bd518008131fe7d8073c82110f4
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10 -add hex mask ffffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10 -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add eToken_JAVA_10B -name 'Aladdin R.D. eToken Java v1.0b' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10B -add hex atr 3bd5180081313a7d8073c8211030
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10B -add hex mask ffffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure eToken_JAVA_10B -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add JaCarta -name 'Aladdin R.D. JaCarta' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta -add hex atr 3bdc18ff8191fe1fc38073c821136601061159000128
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta -add hex mask ffffffffffffffffffffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -add JaCarta_LT -name 'Aladdin R.D. JaCarta LT' > /dev/null
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta_LT -add hex atr 3bdc18ff8111fe8073c82113660106013080018d
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta_LT -add hex mask ffffffffffffffffffffffffffffffffffffffff
/opt/cprocsp/sbin/amd64/cpconfig -hardware media -configure JaCarta_LT -add string folders "CC00\\CC01\\CC02\\CC03\\CC04\\CC05\\CC06\\CC07\\CC08\\CC09"

#Нужен ли этот блок
bash /tmp/PLIST-csp/Linux/update_all_plists.sh > /dev/null 2>&1 
rm -rf /tmp/PLIST-csp > /dev/null 2>&1 

/etc/init.d/pcscd restart > /dev/null 2>&1 
#до этого места

#cprocsp-rdr-kst
cpconfig -ini '\config\apppath' -add string librdrkst.so /opt/cprocsp/lib/amd64/librdrkst.so
cpconfig -ini '\config\KeyCarriers\MORPHOKST' -add string DLL librdrkst.so

cpconfig -hardware media -add MORPHOKST -name 'MorphoKST' > /dev/null
cpconfig -hardware media -configure MORPHOKST -add hex atr 3b6800000073c84000009000
cpconfig -hardware media -configure MORPHOKST -add hex mask ffffffffffffffffffffffff
cpconfig -hardware media -configure MORPHOKST -add string Name 'MorphoKST'

#cprocsp-rdr-mskey
NAME=MSKEY
cpconfig -ini '\config\apppath' -add string librdrmskey.so /opt/cprocsp/lib/amd64/librdrmskey.so
cpconfig -ini "\config\KeyCarriers\\$NAME" -add string DLL librdrmskey.so
cpconfig -hardware media -add $NAME -name $NAME > /dev/null
cpconfig -hardware media -configure $NAME -add hex atr 3b9e00008031c0654d5300000072f7418107
cpconfig -hardware media -configure $NAME -add hex mask ffff0000ffffffffffff300000ffffffffff
cpconfig -hardware media -configure $NAME -add string Name 'Multisoft MSKey'

cpconfig -hardware media -add $NAME -connect MskeyESMART -name 'Multisoft MSKey ESMART' > /dev/null
cpconfig -hardware media -configure $NAME -connect MskeyESMART -add hex atr  3B9796008073F7C1808105
cpconfig -hardware media -configure $NAME -connect MskeyESMART -add hex mask ffffffffffffffffffffff

#cprocsp-rdr-novacard
cpconfig -ini '\config\apppath' -add string librdrnova.so /opt/cprocsp/lib/amd64/librdrnova.so
cpconfig -ini '\config\KeyCarriers\NOVACARD' -add string DLL librdrnova.so

cpconfig -hardware media -add NOVACARD -name 'NOVACARD' > /dev/null
cpconfig -hardware media -configure NOVACARD -add hex atr 3b6f00000031c068435350454d560300009000
cpconfig -hardware media -configure NOVACARD -add hex mask ffffffffffffffffffffffffffffffff00ffff
cpconfig -hardware media -configure NOVACARD -add string folders "0B00\\0B10"
cpconfig -hardware media -configure NOVACARD -add string Name 'Novacard'

#cprocsp-rdr-rutoken
cpconfig -ini '\config\apppath' -add string librdrrutoken.so /opt/cprocsp/lib/amd64/librdrrutoken.so
#
cpconfig -ini '\config\KeyCarriers\RutokenECP' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenECP -name 'Rutoken ECP' > /dev/null
cpconfig -hardware media -configure RutokenECP -add hex atr 3b8b015275746f6b656e20445320c1 
cpconfig -hardware media -configure RutokenECP -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenECP -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenECP -add long size_1 60
cpconfig -hardware media -configure RutokenECP -add long size_2 70
cpconfig -hardware media -configure RutokenECP -add long size_3 8
cpconfig -hardware media -configure RutokenECP -add long size_4 60
cpconfig -hardware media -configure RutokenECP -add long size_5 70
cpconfig -hardware media -configure RutokenECP -add long size_6 300
cpconfig -hardware media -configure RutokenECP -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\RutokenFkcOld' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenFkcOld -name 'CryptoPro Rutoken' > /dev/null
cpconfig -hardware media -configure RutokenFkcOld -add hex atr 3b8b015275746f6b656e20454350a0 
cpconfig -hardware media -configure RutokenFkcOld -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenFkcOld -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenFkcOld -add long size_1 60
cpconfig -hardware media -configure RutokenFkcOld -add long size_2 70
cpconfig -hardware media -configure RutokenFkcOld -add long size_3 8
cpconfig -hardware media -configure RutokenFkcOld -add long size_4 60
cpconfig -hardware media -configure RutokenFkcOld -add long size_5 70
cpconfig -hardware media -configure RutokenFkcOld -add long size_6 300
cpconfig -hardware media -configure RutokenFkcOld -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\RutokenECPSC' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenECPSC -name 'Rutoken ECP SC' > /dev/null
cpconfig -hardware media -configure RutokenECPSC -add hex atr 3b9c96005275746f6b656e4543507363 
cpconfig -hardware media -configure RutokenECPSC -add hex mask ffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenECPSC -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenECPSC -add long size_1 60
cpconfig -hardware media -configure RutokenECPSC -add long size_2 70
cpconfig -hardware media -configure RutokenECPSC -add long size_3 8
cpconfig -hardware media -configure RutokenECPSC -add long size_4 60
cpconfig -hardware media -configure RutokenECPSC -add long size_5 70
cpconfig -hardware media -configure RutokenECPSC -add long size_6 300
cpconfig -hardware media -configure RutokenECPSC -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\RutokenLiteSC2' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenLiteSC2 -name 'Rutoken Lite SC' > /dev/null
cpconfig -hardware media -configure RutokenLiteSC2 -add hex atr 3b9e96005275746f6b656e4c697465534332
cpconfig -hardware media -configure RutokenLiteSC2 -add hex mask ffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenLiteSC2 -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_1 60
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_2 70
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_3 8
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_4 60
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_5 70
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_6 300
cpconfig -hardware media -configure RutokenLiteSC2 -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\RutokenLite' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenLite -name 'Rutoken lite' > /dev/null
cpconfig -hardware media -configure RutokenLite -add hex atr 3b8b015275746f6b656e6c697465c2
cpconfig -hardware media -configure RutokenLite -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenLite -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenLite -add long size_1 60
cpconfig -hardware media -configure RutokenLite -add long size_2 70
cpconfig -hardware media -configure RutokenLite -add long size_3 8
cpconfig -hardware media -configure RutokenLite -add long size_4 60
cpconfig -hardware media -configure RutokenLite -add long size_5 70
cpconfig -hardware media -configure RutokenLite -add long size_6 300
cpconfig -hardware media -configure RutokenLite -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\Rutoken' -add string DLL librdrrutoken.so
cpconfig -hardware media -add Rutoken -name 'Rutoken S' > /dev/null
cpconfig -hardware media -configure Rutoken -add hex atr 3b6f00ff00567275546f6b6e73302000009000
cpconfig -hardware media -configure Rutoken -add hex mask ffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure Rutoken -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000"
cpconfig -hardware media -configure Rutoken -add long size_1 60
cpconfig -hardware media -configure Rutoken -add long size_2 70
cpconfig -hardware media -configure Rutoken -add long size_3 8
cpconfig -hardware media -configure Rutoken -add long size_4 60
cpconfig -hardware media -configure Rutoken -add long size_5 70
cpconfig -hardware media -configure Rutoken -add long size_6 300
cpconfig -hardware media -configure Rutoken -add long size_7 8
#
cpconfig -ini '\config\KeyCarriers\RutokenPinpad' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenPinpad -name 'Rutoken PinPad' > /dev/null
cpconfig -hardware media -configure RutokenPinpad -add hex atr 3B8B01527450494E5061642020329C
cpconfig -hardware media -configure RutokenPinpad -add hex mask ffffffffffffffffffffffffffffff
#
#cpconfig -hardware reader -add "Aktiv Rutoken ECP 00 00" -name 'Rutoken ECP 0'
#cpconfig -hardware reader -add "Aktiv Rutoken ECP 01 00" -name 'Rutoken ECP 1'
#cpconfig -hardware reader -add "Aktiv Rutoken lite 00 00" -name 'Rutoken lite 0'
#cpconfig -hardware reader -add "Aktiv Rutoken lite 01 00" -name 'Rutoken lite 1'
#cpconfig -hardware reader -add "Aktiv Co. Rutoken S 00 00" -name 'Rutoken S 0'
#cpconfig -hardware reader -add "Aktiv Co. Rutoken S 01 00" -name 'Rutoken S 1'
#cpconfig -hardware reader -add "Aktiv Rutoken Magistra 00 00" -name 'Rutoken Magistra 0'
#cpconfig -hardware reader -add "Aktiv Rutoken Magistra 01 00" -name 'Rutoken Magistra 1'

#
cpconfig -ini '\config\KeyCarriers\RutokenECPM' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenECPM -name 'Rutoken ECP 2151' > /dev/null
cpconfig -hardware media -configure RutokenECPM -add hex atr 3B18967275746F6B656E6D 
cpconfig -hardware media -configure RutokenECPM -add hex mask ffffffffffffffffffffff
cpconfig -hardware media -configure RutokenECPM -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenECPM -add long size_1 60
cpconfig -hardware media -configure RutokenECPM -add long size_2 70
cpconfig -hardware media -configure RutokenECPM -add long size_3 3072
cpconfig -hardware media -configure RutokenECPM -add long size_4 60
cpconfig -hardware media -configure RutokenECPM -add long size_5 70
cpconfig -hardware media -configure RutokenECPM -add long size_6 300
cpconfig -hardware media -configure RutokenECPM -add long size_7 8

#
cpconfig -ini '\config\KeyCarriers\RutokenECPMSC' -add string DLL librdrrutoken.so
cpconfig -hardware media -add RutokenECPMSC -name 'Rutoken ECP 2151 SC' > /dev/null
cpconfig -hardware media -configure RutokenECPMSC -add hex atr 3B1A967275746F6B656E6D7363 
cpconfig -hardware media -configure RutokenECPMSC -add hex mask ffffffffffffffffffffffffff
cpconfig -hardware media -configure RutokenECPMSC -add string folders "0A00\\0B00\\0C00\\0D00\\0E00\\0F00\\1000\\1100\\1200\\1300\\1400\\1500\\1600\\1700\\1800"
cpconfig -hardware media -configure RutokenECPMSC -add long size_1 60
cpconfig -hardware media -configure RutokenECPMSC -add long size_2 70
cpconfig -hardware media -configure RutokenECPMSC -add long size_3 3072
cpconfig -hardware media -configure RutokenECPMSC -add long size_4 60
cpconfig -hardware media -configure RutokenECPMSC -add long size_5 70
cpconfig -hardware media -configure RutokenECPMSC -add long size_6 300
cpconfig -hardware media -configure RutokenECPMSC -add long size_7 8

#cprocsp-rdr-cloud
cpconfig -ini '\config\apppath' -add string librdrcloud.so /opt/cprocsp/lib/amd64/librdrcloud.so
cpconfig -ini '\config\KeyDevices\Cloud' -add string DLL librdrcloud.so
cpconfig -ini '\config\KeyDevices\Cloud' -add string AuthApp /opt/cprocsp/sbin/amd64/oauthapp
cpconfig -hardware reader -add Cloud > /dev/null

cpconfig -ini '\config\Parameters\' -add multistring DefaultCloudAuthServer 'https://dss.cryptopro.ru/STS/oauth'
cpconfig -ini '\config\Parameters\' -add multistring DefaultCloudRestServer 'https://dss.cryptopro.ru/SignServer/rest'

cpconfig -ini '\config\debug' -add string cloud 262144

#cprocsp-rdr-cpfkc
cpconfig -ini '\config\apppath' -add string librdrcpfkc.so /opt/cprocsp/lib/amd64/librdrcpfkc.so
cpconfig -ini '\config\KeyCarriers\fkchdimg' -add string DLL librdrcpfkc.so
cpconfig -ini '\config\KeyCarriers\gemfkc' -add string DLL librdrcpfkc.so
cpconfig -ini '\config\KeyCarriers\nxpfkc' -add string DLL librdrcpfkc.so
cpconfig -ini '\config\KeyCarriers\rutokenfkc' -add string DLL librdrcpfkc.so
cpconfig -ini '\config\KeyCarriers\smartparkfkc' -add string DLL librdrcpfkc.so

cpconfig -hardware media -add fkchdimg -name 'fkchdimg' > /dev/null
cpconfig -hardware media -configure fkchdimg -connect Default -add hex atr 3B6F00FF006370656d756c666b632000009000
cpconfig -hardware media -configure fkchdimg -connect Default -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
cpconfig -hardware media -configure fkchdimg -connect Default -add string Name 'FKC emulator'
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\01' -add long Is_functional 1
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\01' -add long Auth_type 3
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\01' -add string Unique "CProEmul_123456_2012"
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\02' -add long Is_functional 1
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\02' -add long Auth_type 2
cpconfig -ini '\config\KeyCarriers\fkchdimg\Default\02' -add string Unique "CProEmul_123456_Pass"

cpconfig -hardware media -add gemfkc -name 'gemfkc' > /dev/null
cpconfig -hardware media -configure gemfkc -connect Default -add hex atr 3BFF9600008131FE4380318065B0845C59FB12FFFE829000FB
cpconfig -hardware media -configure gemfkc -connect Default -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure gemfkc -connect Default -add string Name 'Gemalto FKC'

cpconfig -hardware media -add nxpfkc -name 'nxpfkc' > /dev/null
cpconfig -hardware media -configure nxpfkc -connect Default -add hex atr 3BDC18FF8191FE1FC38073C821136605036351000250
cpconfig -hardware media -configure nxpfkc -connect Default -add hex mask ffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure nxpfkc -connect Default -add string Name 'CryptoPro NXP'

cpconfig -hardware media -add rutokenfkc -name 'rutokenfkc' > /dev/null
cpconfig -hardware media -configure rutokenfkc -connect Default -add hex atr 3b8b015275746f6b656e20445320c1
cpconfig -hardware media -configure rutokenfkc -connect Default -add hex mask ffffffffffffffffffffffffffffff
cpconfig -hardware media -configure rutokenfkc -connect Default -add string Name 'Rutoken FKC'

cpconfig -hardware media -add smartparkfkc -name 'smartparkfkc' > /dev/null
cpconfig -hardware media -configure smartparkfkc -connect Default -add hex atr 3B000000534D4152545041524B20464B43
cpconfig -hardware media -configure smartparkfkc -connect Default -add hex mask ff000000ffffffffffffffffffffffffff
cpconfig -hardware media -configure smartparkfkc -connect Default -add string Name 'SmartPark FKC'

#cprocsp-rdr-infocrypt
cpconfig -ini '\config\apppath' -add string librdrinfocrypt.so /opt/cprocsp/lib/amd64/librdrinfocrypt.so

cpconfig -ini '\config\KeyCarriers\TokenPlusPlusLite' -add string DLL librdrinfocrypt.so
cpconfig -hardware media -add TokenPlusPlusLite -name 'TokenPlusPlusLite' > /dev/null
cpconfig -hardware media -configure TokenPlusPlusLite -add hex atr 3bdf18008131fe670056496e666f43727330200000900054
cpconfig -hardware media -configure TokenPlusPlusLite -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure TokenPlusPlusLite -add string Name 'InfoCrypt Token++ lite'
cpconfig -hardware media -configure TokenPlusPlusLite -add string folders '2000\1FFF\1FFE\1FFD\1FFC\1FFB\1FFA\1FF9\1FF8\1FF7\1FF6\1FF5'

cpconfig -ini '\config\KeyCarriers\TokenPlusPlusTls' -add string DLL librdrinfocrypt.so
cpconfig -hardware media -add TokenPlusPlusTls -name 'TokenPlusPlusTls' > /dev/null
cpconfig -hardware media -configure TokenPlusPlusTls -add hex atr 3bdf18008131fe67005c49434dd49147d279000038330057
cpconfig -hardware media -configure TokenPlusPlusTls -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure TokenPlusPlusTls -add string Name 'InfoCrypt Token++ tls'

cpconfig -ini '\config\KeyCarriers\VPNKEYTLS' -add string DLL librdrinfocrypt.so
cpconfig -hardware media -add VPNKEYTLS -name 'VPNKEYTLS' > /dev/null
cpconfig -hardware media -configure VPNKEYTLS -add hex atr 3bdf18008131fe67005c49434dd49147d276000038330058
cpconfig -hardware media -configure VPNKEYTLS -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure VPNKEYTLS -add string Name 'InfoCrypt VPN-Key-TLS'

cpconfig -ini '\config\KeyCarriers\TokenPlusPlus' -add string DLL librdrinfocrypt.so
cpconfig -hardware media -add TokenPlusPlus -name 'TokenPlusPlus' > /dev/null
cpconfig -hardware media -configure TokenPlusPlus -add hex atr 3bdf18008131fe67005c49434dd49147d277000038330059
cpconfig -hardware media -configure TokenPlusPlus -add hex mask ffffffffffffffffffffffffffffffffffffffffffffffff
cpconfig -hardware media -configure TokenPlusPlus -add string Name 'InfoCrypt Token++'

#cprocsp-rdr-rosan
cpconfig -ini '\config\apppath' -add string librdrrosan.so /opt/cprocsp/lib/amd64/librdrrosan.so
cpconfig -ini '\config\KeyCarriers\ROSAN' -add string DLL librdrrosan.so

cpconfig -hardware media -add ROSAN -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -add hex atr 3B6800000073C84000009000
cpconfig -hardware media -configure ROSAN -add hex mask FFFFFFFFFFFFFFFF00FFFFFF
cpconfig -hardware media -configure ROSAN -add string folders "D01\\D02\\D03\\D04\\D05"

cpconfig -hardware media -add ROSAN -connect Rosan_GD -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add hex atr 3BFF9700008031FE450031C173C82110640000000000900000
cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFF00
cpconfig -hardware media -configure ROSAN -connect Rosan_GD -add string folders "D01\\D02\\D03\\D04\\D05"

cpconfig -hardware media -add ROSAN -connect Rosan_GD1 -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add hex atr 3BFD9700008031FE450031C071C6644D35000001900000
cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF00
cpconfig -hardware media -configure ROSAN -connect Rosan_GD1 -add string folders "D01\\D02\\D03\\D04\\D05"

cpconfig -hardware media -add ROSAN -connect Rosan_GD2 -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add hex atr 3BE800008131FE450073C840130090009B
cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
cpconfig -hardware media -configure ROSAN -connect Rosan_GD2 -add string folders "D01\\D02\\D03\\D04\\D05"

cpconfig -hardware media -add ROSAN -connect Rosan_GD3 -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add hex atr 3B6D00000073C800136454000000009000
cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add hex mask FFFFFFFFFFFFFFFFFFFFFF000000FFFFFF
cpconfig -hardware media -configure ROSAN -connect Rosan_GD3 -add string folders "D01\\D02\\D03\\D04\\D05"

cpconfig -hardware media -add ROSAN -connect Rosan_GD4 -name 'Rosan' > /dev/null
cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add hex atr 3B7E9600000031C071C665740B041631019000
cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add hex mask FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
cpconfig -hardware media -configure ROSAN -connect Rosan_GD4 -add string folders "D01\\D02\\D03\\D04\\D05"

#lsb-cprocsp-pkcs11
cpconfig -ini '\config\apppath' -add string libcppkcs11.so /opt/cprocsp/lib/amd64/libcppkcs11.so
cpconfig -ini '\config\PKCS11\slot0' -add string "ProvGOST" ""
cpconfig -ini '\config\PKCS11\slot0' -add string "Firefox" ""
cpconfig -ini '\config\PKCS11\slot0' -add string "reader" ""


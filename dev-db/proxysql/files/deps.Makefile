PROXYDEBUG := $(shell echo $(PROXYDEBUG))
ifeq ($(PROXYDEBUG),1)
MYCFLAGS=-O0
MYJEOPT=--enable-xmalloc --enable-prof --enable-fill --enable-debug
else
MYCFLAGS=-O2
MYJEOPT=--enable-xmalloc --enable-prof
endif

.PHONY: default
default: coredumper

google-coredumper/google-coredumper/.libs/libcoredumper.a:
	cd google-coredumper && rm -rf google-coredumper || true
	cd google-coredumper && tar -zxf google-coredumper.tar.gz
	cd google-coredumper/google-coredumper && ./configure && CC=${CC} CXX=${CXX} ${MAKE}
coredumper: google-coredumper/google-coredumper/.libs/libcoredumper.a

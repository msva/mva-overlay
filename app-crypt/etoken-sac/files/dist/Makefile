# Some functions for candiness-looking
err =						\
	@echo -e " \e[1;31m*\e[0m $(1)\e[0m";	\
	@exit 1;
inf =						\
	@echo -e " \e[1;32m*\e[0m $(1)\e[0m";
wrn =						\
	@echo -e " \e[1;33m*\e[0m $(1)\e[0m";
ext =						\
	@echo -e " \e[1;35m*\e[0m $(1)\e[0m";

# LibVersion
PV ?= 9.1.7
P ?= etoken-sac-$(PV)
ARCH := $(shell uname -m)
DESTDIR ?= /

ifeq ($(ARCH), x86_64)
	LIBDIR := lib64
else ifeq ($(ARCH),i386)
	LIBDIR := lib
else ifeq ($(ARCH),i486)
	LIBDIR := lib
else ifeq ($(ARCH),i586)
	LIBDIR := lib
else ifeq ($(ARCH),i686)
	LIBDIR := lib
endif
#LIBDIR := $(if $(shell [[ $(ARCH) =~ i.86 ]] && echo x86),lib,lib64)

prepare:
	@ $(call inf,"Preparing image...")
ifeq ($(ARCH),x86_64)
	@ mv lib lib32
	@ mkdir lib
	@ mv lib32/udev lib/udev
	@ mv usr/lib usr/lib32
	@ sh -c 'find usr/lib32 -type l | while read lib; do nlib=$$(readlink $${lib}); ln -sf $${nlib/\/lib\//\/lib32\/} $${lib}; done'
endif
	@ mkdir -p usr/$(LIBDIR)/readers/usb
	@ ln -s ../../../share/eToken/drivers/aks-ifdh.bundle usr/$(LIBDIR)/readers/usb/aks-ifdh.bundle
	@ mkdir -p etc/conf.d/ && touch etc/conf.d/SACSrv
	@ mv usr/share/doc/eToken usr/share/doc/$(P)
	@ mkdir -p image; mv etc lib* usr image/; rm -r var
	@ $(call inf,"Done!")
install:
	@ $(call inf,"Installing...")
	@ cp -a image/* $(DESTDIR)
	@ $(call inf,"Done!")
clean:
	@ $(call inf,"Nothing to do...")

uninstall: clean

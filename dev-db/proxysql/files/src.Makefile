DEPS_PATH=../deps
IDIR=../include
LDIR=../lib
IDIRS=-I$(IDIR)
LDIRS=-L$(LDIR)

MARIADB_PATH=$(DEPS_PATH)/mariadb-client-library/mariadb_client
MARIADB_IDIR=$(MARIADB_PATH)/include
MARIADB_LDIR=$(MARIADB_PATH)/libmariadb

COREDUMPER_DIR=$(DEPS_PATH)/google-coredumper/google-coredumper
COREDUMPER_IDIR=$(COREDUMPER_DIR)/src
COREDUMPER_LDIR=$(COREDUMPER_DIR)/.libs

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
	IDIRS+= -I/usr/local/include -I/usr/local/opt/openssl/include
	LDIRS+= -L/usr/local/lib
endif

LDFLAGS+=
MYLIBS=-lconfig -lproxysql -ldaemon -lconfig++ -lre2 -lpcrecpp -lpcre -lmariadb -lmicrohttpd -lcurl -lev -lcoredumper -lpthread -lm -lz -lrt $(EXTRALINK)

PROXYSQLCLICKHOUSE := $(shell echo $(PROXYSQLCLICKHOUSE))
ifeq ($(PROXYSQLCLICKHOUSE),1)
PSQLCH=-DPROXYSQLCLICKHOUSE
MYLIBS+=-lclickhouse-cpp-lib -lcityhash -llz4
else
PSQLCH=
endif

MYCXXFLAGS=-std=c++11 $(IDIRS) $(OPTZ) $(DEBUG) $(PSQLCH) -DGITVERSION=\"$(PV)\"

ifeq ($(UNAME_S),Darwin)
	MYLIBS=-lssl -lre2 -lmariadbclient -lpthread -lm -lz -liconv -lcrypto -lcurl
endif
ifeq ($(UNAME_S),Linux)
	MYLIBS+= -ldl
endif
ifeq ($(UNAME_S),FreeBSD)
	MYLIBS+= -lexecinfo
endif

ODIR= obj

EXECUTABLE=proxysql

_OBJ = main.o proxysql_global.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.cpp
	$(CXX) -c -o $@ $< $(MYCXXFLAGS) $(CXXFLAGS) -Wall

proxysql: $(ODIR) $(OBJ)
	$(CXX) -o $@ $(OBJ) $(MYCXXFLAGS) $(CXXFLAGS) $(LDIRS) $(LIBS) $(LDFLAGS) $(MYLIBS)

$(ODIR):
	mkdir $(ODIR)

default: $(EXECUTABLE)

clean:
	rm -f *.pid $(ODIR)/*.o *~ core perf.data* heaptrack.proxysql.* $(EXECUTABLE)


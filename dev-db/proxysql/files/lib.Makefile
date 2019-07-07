DEPS_PATH=../deps

COREDUMPER_DIR=$(DEPS_PATH)/google-coredumper/google-coredumper
COREDUMPER_IDIR=$(COREDUMPER_DIR)/src

IDIR=../include

ODIR= obj

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
NOJEM=-DNOJEM
endif

PROXYSQLCLICKHOUSE := $(shell echo $(PROXYSQLCLICKHOUSE))
ifeq ($(PROXYSQLCLICKHOUSE),1)
PSQLCH=-DPROXYSQLCLICKHOUSE
else
PSQLCH=
endif

ifeq ($(UNAME_S),Darwin)
	IDIRS+= -I/usr/local/opt/openssl/include
endif

# TODO: pkg-config/mysql-config
IDIRS=-I$(IDIR) -I/usr/include/mysql -I/usr/include/mariadb -I/usr/include/jemalloc

MYCFLAGS=$(IDIRS) $(OPTZ) $(DEBUG) -Wall -DGITVERSION=\"$(PV)\" $(NOJEM) -DCACHE_LINE_SIZE=64
MYCXXFLAGS=-std=c++11 $(MYCFLAGS) $(PSQLCH)

default: libproxysql.so
.PHONY: default

_OBJ = c_tokenizer.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))
_OBJ_CXX = ProxySQL_GloVars.oo network.oo debug.oo configfile.oo Query_Cache.oo SpookyV2.oo MySQL_Authentication.oo gen_utils.oo sqlite3db.oo mysql_connection.oo MySQL_HostGroups_Manager.oo mysql_data_stream.oo MySQL_Thread.oo MySQL_Session.oo MySQL_Protocol.oo mysql_backend.oo Query_Processor.oo ProxySQL_Admin.oo MySQL_Monitor.oo MySQL_Logger.oo thread.oo MySQL_PreparedStatement.oo ProxySQL_Cluster.oo SQLite3_Server.oo ClickHouse_Authentication.oo ClickHouse_Server.oo ProxySQL_Statistics.oo Chart_bundle_js.oo ProxySQL_HTTP_Server.oo font-awesome.min.css.oo main-bundle.min.css.oo set_parser.oo
OBJ_CXX = $(patsubst %,$(ODIR)/%,$(_OBJ_CXX))

%.ko: %.cpp
	$(CXX) -fPIC -c -o $@ $< $(MYCXXFLAGS) $(CXXFLAGS)

$(ODIR)/%.o: %.c
	$(CC) -fPIC -c -o $@ $< $(MYCFLAGS) $(CFLAGS)

$(ODIR)/%.oo: %.cpp
	$(CXX) -fPIC -c -o $@ $< $(MYCXXFLAGS) $(CXXFLAGS)

libproxysql.so: $(ODIR) $(OBJ) $(OBJ_CXX)
	$(CC) -fPIC -c -o $@ $< $(MYCXXFLAGS) $(CXXFLAGS)

$(ODIR):
	mkdir $(ODIR)

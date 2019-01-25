CC ?= cc
package ?= "lyaml"
version ?= "git:HEAD"
DEBUG ?= NDEBUG
LUA_INCDIR ?= /usr/include/lua5.1
CF ?= -fPIC -O2 -DPACKAGE='"$(package)"' -D$(DEBUG) -DVERSION='"$(version)"' -Iext/include -I/usr/include -I$(LUA_INCDIR) $(CFLAGS)
LF ?= -shared -L/usr/lib64 -L/usr/lib32 -L/usr/libx32 -L/usr/lib -lyaml $(LDFLAGS)

SOURCES = ext/yaml/yaml.c ext/yaml/emitter.c ext/yaml/parser.c ext/yaml/scanner.c
SONAME = yaml.so

all:
	$(CC) $(CF) $(SOURCES) $(LF) -o $(SONAME)
doc:
	ldoc -c build-aux/config.ld.in .

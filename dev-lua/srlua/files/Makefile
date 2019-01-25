all:
	$(CC) $(CFLAGS) -o glue srglue.c
	$(CC) $(CFLAGS) -o srlua srlua.c -Wl,-E $(STATIC) -ldl $(LUA_LINK_LIB)


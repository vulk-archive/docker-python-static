.PHONY: all setup clean

all: python
setup: Modules/Setup

PYTHON=python
PREFIX=/usr/local/python-static
#PREFIX=/usr/local
CONF_ARGS=
MAKE_ARGS=-j 6 install
BUILTINS=
# removed _datetime and renamed _operator to operator
override BUILTINS+= array cmath math _struct time operator _random _collections _heapq itertools _functools _elementtree pickle _bisect unicodedata atexit _weakref datetime
SCRIPT=
DFLAG=
CPPFLAGS=
LDFLAGS=
INCLUDE=-I/usr/include

Modules/Setup: Modules/Setup.dist add_builtins.py
	sed -e 's/#\*shared\*/\*static\*/g' Modules/Setup.dist \
	> Modules/Setup
	cat StaticSetup >> Modules/Setup

	[ -d Modules/extras ] || mkdir Modules/extras
	$(PYTHON) add_builtins.py $(BUILTINS) $(DFLAG) -s $(SCRIPT)

Makefile: Modules/Setup
	[ -d $(PREFIX) ] || mkdir $(PREFIX)
	./configure LDFLAGS="-Wl,-no-export-dynamic -static-libgcc -static $(LDFLAGS) $(INCLUDE)" \
		CPPFLAGS="-I/usr/lib -static -fPIC $(CPPLAGS) $(INCLUDE)" LINKFORSHARED=" " \
		DYNLOADFILE="dynload_stub.o" -disable-shared \
		-prefix="$(PREFIX)" $(CONF_ARGS)

python: Modules/Setup Makefile
	make $(MAKE_ARGS)

clean: 
	make clean
	rm -f Makefile Modules/Setup

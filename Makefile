# freemem version
VERSION = 0.2

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man

# flags
CPPFLAGS = -D_XOPEN_SOURCE=700 -D_BSD_SOURCE -DVERSION=\"${VERSION}\"
CFLAGS   = -std=c11 -pedantic -Wall ${CPPFLAGS}

# compiler and linker
CC = cc

SRC = freemem.c 
OBJ = ${SRC:.c=.o}

all: options freemem

options:
	@echo freemem build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

freemem: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ}

clean:
	@echo cleaning
	@rm -f freemem freemem.core ${OBJ}

dist: clean
	@echo creating dist tarball
	@mkdir -p freemem-${VERSION}
	@cp -R LICENSE TODO BUGS Makefile README freemem.c \
		freemem.1 ${SRC} freemem-${VERSION}
	@tar -cf freemem-${VERSION}.tar freemem-${VERSION}
	@gzip freemem-${VERSION}.tar
	@rm -rf freemem-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f freemem ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/freemem
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < freemem.1 > ${DESTDIR}${MANPREFIX}/man1/freemem.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/freemem.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/freemem
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/freemem.1

.PHONY: all options clean dist install uninstall

# Copyright (c) 2009-2010 by Aleksey Cheusov
# Copyright (c) 1994-2009 The NetBSD Foundation, Inc.
# Copyright (c) 1988, 1989, 1993 The Regents of the University of California
# Copyright (c) 1988, 1989 by Adam de Boor
# Copyright (c) 1989 by Berkeley Softworks
#
# See COPYRIGHT file in the distribution.
############################################################

.if !defined(_MKC_IMP_PROG_MK)
_MKC_IMP_PROG_MK := 1

.PHONY:		proginstall
proginstall:

CFLAGS +=	${COPTS}

__proginstall: .USE
	${INSTALL} ${RENAME} ${PRESERVE} ${COPY} ${STRIPFLAG} \
	    -o ${BINOWN} -g ${BINGRP} -m ${BINMODE} ${.ALLSRC} ${.TARGET}

.for p in ${PROGS}
realinstall:	proginstall

DPSRCS.${p} =	${SRCS.${p}:M*.l:.l=.c} ${SRCS.${p}:M*.y:.y=.c}
CLEANFILES +=	${DPSRCS.${p}}
.if defined(YHEADER)
CLEANFILES +=	${SRCS.${p}:M*.y:.y=.h}
.endif # defined(YHEADER)

OBJS.${p} =	${SRCS.${p}:N*.h:N*.sh:N*.fth:T:R:S/$/.o/g}

.if defined(OBJS.${p}) && !empty(OBJS.${p})
.NOPATH: ${OBJS.${p}}

${p}: ${LIBCRT0} ${DPSRCS.${p}} ${OBJS.${p}} ${LIBC} ${LIBCRTBEGIN} ${LIBCRTEND} ${DPADD}
.if !commands(${p})
	${MESSAGE.ld}
	${_V}${LDREAL} ${LDFLAGS} ${LDFLAGS.prog} ${LDSTATIC} \
		-o ${.TARGET} ${OBJS.${p}} ${LDADD}
.endif # !commands(...)

.endif	# defined(OBJS.${p}) && !empty(OBJS.${p})

.if !defined(MAN) && exists(${p}.1)
MAN +=		${p}.1
.endif # !defined(MAN)

PROGNAME.${p} ?=	${PROGNAME:U${p}}

.if ${MKINSTALL:tl} == "yes"
dest_prog.${p}   =	${DESTDIR}${BINDIR}/${PROGNAME.${p}}
UNINSTALLFILES  +=	${dest_prog.${p}}
INSTALLDIRS     +=	${dest_prog.${p}:H}

proginstall: ${dest_prog.${p}}
.PRECIOUS:    ${dest_prog.${p}}
.PHONY:       ${dest_prog.${p}}
.endif # ${MKINSTALL:tl} == "yes"

${DESTDIR}${BINDIR}/${PROGNAME.${p}}: ${p} __proginstall

CLEANFILES +=	${OBJS.${p}}

.endfor # ${PROGS}

realall: ${PROGS}

CLEANFILES += a.out [Ee]rrs mklog core *.core ${PROGS}

.endif # _MKC_IMP_PROG_MK

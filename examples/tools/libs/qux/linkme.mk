PATH.qux  :=	${.PARSEDIR}

CPPFLAGS  +=	-I${PATH.qux}
DPLIBDIRS +=	${PATH.qux}
LDADD     +=	-lqux

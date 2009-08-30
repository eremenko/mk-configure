.PHONY : test
test:
	${MAKE} distclean; \
	${MAKE} all 2>&1 | \
	    awk '/Error code/ {exit 0} {print}' >${.OBJDIR}/_output.tmp; \
	diff ${.CURDIR}/expect.out ${.OBJDIR}/_output.tmp 

CLEANFILES+=	_output.tmp
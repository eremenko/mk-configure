# Copyright (c) 2009, Aleksey Cheusov <vle@gmx.net>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# For documentation see README file

.include <mkc.common.mk>

.PHONY: cleandir distclean clean localclean
cleandir distclean clean: localclean
localclean:
	rm -f ${CLEANFILES}

.if defined(MKC_NOBSDMK) && !empty(MKC_NOBSDMK:M[Yy][Ee][Ss])
.include <subdir.mk>
.else
.include <bsd.subdir.mk>
.endif

.PHONY : install-dirs
install-dirs:
.for d in ${SUBDIR}
	@if test "${d}" != .WAIT; then \
		cd ${.CURDIR}/"${d}" && ${MAKE} ${MAKEFLAGS} install-dirs; \
	fi
.endfor

#.PHONY : distclean
#distclean:
#.for d in ${SUBDIR}
#	@if test "${d}" != .WAIT; then \
#		cd ${.CURDIR}/"${d}" && ${MAKE} ${MAKEFLAGS} distclean; \
#	fi
#.endfor

.PHONY : uninstall
uninstall:
.for d in ${SUBDIR}
	@if test "${d}" != .WAIT; then \
		cd ${.CURDIR}/"${d}" && ${MAKE} ${MAKEFLAGS} uninstall; \
	fi
.endfor

.if !target(test)
.PHONY : test
test:
	@ex=0; \
	for d in ${SUBDIR}; do \
	   if test "$${d}" != .WAIT; then \
		if cd ${.CURDIR}/"$${d}" && ${MAKE} ${MAKEFLAGS} test; then true; else \
			ex=1; \
		fi; \
	   fi; \
	done; \
	exit $$ex
.endif

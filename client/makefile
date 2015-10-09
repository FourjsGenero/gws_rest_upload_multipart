#
# FOURJS_START_COPYRIGHT(U,2000)
# Property of Four Js*
# (c) Copyright Four Js 2000, 2015. All Rights Reserved.
# * Trademark of Four Js Development Tools Europe Ltd
#   in the United States and elsewhere
# 
# Four Js and its suppliers do not warrant or guarantee that these samples
# are accurate and suitable for your purposes. Their inclusion is purely for
# information purposes only.
# FOURJS_END_COPYRIGHT
#

COMP = fglcomp
LINK = fgllink
FORM = fglform
WSDL = fglwsdl
RUN = fglrun

.SUFFIXES: .4gl .42r .42m .42f .per
.4gl.42m:
	$(COMP) $<

.per.42f:
	$(FORM) $<

OBJS=   \
  FileUploadClient.42m 


all: FileUploadClient.42r

run:
	$(RUN) FileUploadClient.42r


clean:
	rm -f *.42?


FileUploadClient.42r: $(OBJS)
	$(LINK) -o $@ $(OBJS)


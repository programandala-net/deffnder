# Makefile

# This file is part of DEFFNder
# (http://programandala.net/en.program.deffnder.html)

################################################################
# Author and license

# Copyright (C) 2014,2015,2016 Marcos Cruz (programandala.net)

# You may do whatever you want with this work, so long as you retain
# the copyright notice(s) and this license in all redistributed
# copies and derived works. There is no warranty.

################################################################
# Requirements

# Pasmo (by Julián Albo)
# http://pasmo.speccy.org/

# Optionally, to create a +3 disk image:
# tap2dsk from the Taptools (by John Elliott):
# http://www.seasip.info/ZX/unix.html

# Optionally, to create a +D disk image:
# mkmgt (by Marcos Cruz):
# http://programandala.net/en.program.mkmgt.html

################################################################
# History of this file

# 2014-12-10: First draft.
# 2015-01-22: Changes.
# 2015-03-10: Typo.
# 2015-08-10: Several improvements. New: +D disk image.
# 2015-08-13: Typo in the MGT filename.
# 2016-01-07: Included the demo in the zip file.

################################################################
# Config

#VPATH = ./:./src:deffnder:../deffnder
VPATH = ./:./src
MAKEFLAGS = --no-print-directory

################################################################
# Main

.PHONY: all
all: tap

################################################################
# XXX TODO

#all:
#%.tap : %.z80s
#. tap.z80s :
#	@echo -v --tap --name $* $(.SOURCE) $(.TARGET)
#	pasmo -v --tap --name $* $(.SOURCE) $(.TARGET)

#pasmo -v --tap --name $* $(.SOURCE) $(.TARGET)
#fn_trunc.tap : fn_trunc.z80s
#	@echo -v --tap --name $* $(.SOURCE) $(.TARGET)

# files=$(ls -1 fn_*.z80s)
# for file in $files
# do
# 	name=${file%%.z80s}
# 	pasmo -v --tap --name $name $name.z80s $name.tap
# done

################################################################
# Binaries

source_files = $(wildcard src/fn_*.z80s)

# XXX TODO
#bin/%.tap : src/%.z80s
#	pasmo --tap --name $* $< $@ ../bin/$*.symbols.z80s

# TAP files

tap: $(source_files)
	cd src ; \
	for source in $$(ls -1 fn_*.z80s) ; do \
  		base_name=$${source%%.z80s} ; \
		echo "Compiling $$source" ; \
		pasmo --tap --name $$base_name $$source ../bin/$$base_name.tap ../bin/$$base_name.symbols.z80s ; \
	done ; \
	cd - ; \
	cat bin/fn_*.tap > bin/deffnder.tap

# +3 disk image

dsk: tap
	tap2dsk -180 -label DEFFNder bin/deffnder.tap bin/deffnder.dsk

# +D disk image, with the G+DOS system file

mgt: tap
	mkmgt bin/deffnder.mgt sys/gplusdos-sys-2a.tap bin/deffnder.tap

################################################################
# Archives

packed_files = \
	deffnder/README.adoc \
	deffnder/LICENSE.txt \
	deffnder/Makefile \
	deffnder/sys/*.tap \
	deffnder/src/*.z80s \
	deffnder/bin/* \
	deffnder/demo/*

# XXX TODO
# tar.gz: dsk
# 	tar \
# 	--create \
# 	--gzip \
# 	--file deffnder.tar.gz \
# 	--dereference \
# 	--hard-dereference \
# 	--directory .. \
# 	$(packed_files)

.PHONY: zip
zip:
	cd .. && \
	zip -9 deffnder/deffnder.zip \
	$(packed_files)

################################################################
# Clean

.PHONY: clean
clean:
	-rm -f bin/*


# This file was generated using the following command:
# ./configure --shared --fst-root=/triton/ics/project/puhe/Modules/opt/openfst/openfst-1.4.1 --threaded-math=no --openblas-root=/usr --mathlib=OPENBLAS --use-cuda=no

# Rules that enable valgrind debugging ("make valgrind")

valgrind: .valgrind

.valgrind:
	echo -n > valgrind.out
	for x in $(TESTFILES); do echo $$x>>valgrind.out; valgrind ./$$x >/dev/null 2>> valgrind.out; done
	! ( grep 'ERROR SUMMARY' valgrind.out | grep -v '0 errors' )
	! ( grep 'definitely lost' valgrind.out | grep -v -w 0 )
	rm valgrind.out
	touch .valgrind


KALDI_FLAVOR := dynamic
KALDILIBDIR := /triton/ics/project/puhe/Modules/opt/kaldi/kaldi-${KALDI_COMMIT}/src/lib
CONFIGURE_VERSION := 2
FSTROOT = /triton/ics/project/puhe/Modules/opt/openfst/openfst-1.4.1
OPENFST_VER = 1.4.1
OPENFST_GE_10400 = 1
OPENFSTLIBS = -L/triton/ics/project/puhe/Modules/opt/openfst/openfst-1.4.1/lib -lfst
OPENFSTLDFLAGS = -Wl,-rpath=/triton/ics/project/puhe/Modules/opt/openfst/openfst-1.4.1/lib
OPENBLASLIBS = -L/usr/lib64 -lopenblas -lgfortran -llapack 
OPENBLASROOT = /usr
EXTRA_CXXFLAGS += -DHAVE_OPENFST_GE_10400 -std=c++0x -I${OPENBLASROOT}/include/openblas

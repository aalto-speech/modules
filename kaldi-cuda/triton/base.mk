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
KALDILIBDIR := /triton/ics/project/puhe/Modules/opt/kaldi-cuda/kaldi-cuda-${KALDI_COMMIT}/src/lib
CONFIGURE_VERSION := 2
FSTROOT = /triton/ics/project/puhe/Modules/opt/openfst/openfst-1.3.4
OPENFST_VER = 1.3.4
OPENFST_GE_10400 = 0
OPENFSTLIBS = -L/triton/ics/project/puhe/Modules/opt/openfst/openfst-1.3.4/lib -lfst
OPENFSTLDFLAGS = -Wl,-rpath=/triton/ics/project/puhe/Modules/opt/openfst/openfst-1.3.4/lib
OPENBLASLIBS = -L/usr/lib64 -lopenblas -lgfortran -llapack 
OPENBLASROOT = /usr
EXTRA_CXXFLAGS += -I${OPENBLASROOT}/include/openblas


#Cuda stuff
CUDA = true
CUDATKDIR = /cvmfs/fgi.csc.fi/devel/cuda/cudatoolkit-6.5.14

CUDA_INCLUDE= -I$(CUDATKDIR)/include
CUDA_FLAGS = -g -Xcompiler -fPIC --verbose --machine 64 -DHAVE_CUDA

EXTRA_CXXFLAGS += -DHAVE_CUDA -I$(CUDATKDIR)/include 
UNAME := $(shell uname)
#aware of fact in cuda60 there is no lib64, just lib.
ifeq ($(UNAME), Darwin)
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib -Wl,-rpath,$(CUDATKDIR)/lib
else
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib64 -Wl,-rpath,$(CUDATKDIR)/lib64
endif
CUDA_LDLIBS += -lcublas -lcudart #LDLIBS : The libs are loaded later than static libs in implicit rule

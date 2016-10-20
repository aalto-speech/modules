#makefiles/common.mk
# Rules that enable valgrind debugging ("make valgrind")

valgrind: .valgrind

.valgrind:
	echo -n > valgrind.out
	for x in $(TESTFILES); do echo $$x>>valgrind.out; valgrind ./$$x >/dev/null 2>> valgrind.out; done
	! ( grep 'ERROR SUMMARY' valgrind.out | grep -v '0 errors' )
	! ( grep 'definitely lost' valgrind.out | grep -v -w 0 )
	rm valgrind.out
	touch .valgrind
##########################################

#KALDI_FLAVOR := dynamic
#KALDILIBDIR := $(BUILD_DIR)/src/lib
CONFIGURE_VERSION := 4
#FSTROOT = $FSTROOT)
OPENFST_VER = $(FSTVER)
OPENFST_GE_10400 = 1
EXTRA_CXXFLAGS += -DHAVE_OPENFST_GE_10400 -std=c++0x
OPENFSTLIBS = -L$(FSTROOT)/lib -lfst
OPENFSTLDFLAGS = -Wl,-rpath=$(FSTROOT)/lib


DOUBLE_PRECISION = 0
CXXFLAGS = $(COMPILER_CXXFLAGS) -pthread -Wall -I.. \
      -DKALDI_DOUBLEPRECISION=$(DOUBLE_PRECISION) \
      -Wno-sign-compare -Winit-self \
      -DHAVE_EXECINFO_H=1 -rdynamic -DHAVE_CXXABI_H \
      $(CXXFLAGS_MATH) \
      -I$(FSTROOT)/include \
      $(EXTRA_CXXFLAGS)

ifeq ($(KALDI_FLAVOR), dynamic)
CXXFLAGS += -fPIC
endif

LDFLAGS = -rdynamic $(OPENFSTLDFLAGS) -Wl,-rpath,/share/apps/easybuild/software/GCCcore/4.9.3/lib64
LDLIBS = $(COMPILER_LIBS) $(EXTRA_LDLIBS) $(OPENFSTLIBS) $(MATHLIBS) -lm -lpthread -ldl 

CUDA = true
#CUDATKDIR = $(EBROOTCUDA)
#CUDA_ARCH = -gencode arch=compute_20,code=sm_20 -gencode arch=compute_37,code=sm_37

#RANLIB = ranlib
AS = as 

#makefiles/cuda_64bit.mk

ifndef DOUBLE_PRECISION
$(error DOUBLE_PRECISION not defined.)
endif


CUDA_INCLUDE= -I$(CUDATKDIR)/include
CUDA_FLAGS = -g -Xcompiler -fPIC --verbose --machine 64 -DHAVE_CUDA \
             -DKALDI_DOUBLEPRECISION=$(DOUBLE_PRECISION)
CXXFLAGS += -DHAVE_CUDA -I$(CUDATKDIR)/include
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib64 -Wl,-rpath,$(CUDATKDIR)/lib64
CUDA_LDLIBS += -lcublas -lcudart -lcurand #LDLIBS : The libs are loaded later than static libs in implicit rule

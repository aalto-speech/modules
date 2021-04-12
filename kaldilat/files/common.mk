#makefiles/common.mk
# Rules that enable valgrind debugging ("make valgrind")

##########################################

#KALDI_FLAVOR := dynamic
#KALDILIBDIR := $(BUILD_DIR)/src/lib
CONFIGURE_VERSION := 6
#FSTROOT = $FSTROOT)
OPENFST_VER = $(FSTVER)
OPENFST_GE_10400 = 1
EXTRA_CXXFLAGS += -DHAVE_OPENFST_GE_10400 -std=c++11
OPENFSTLIBS = $(FSTROOT)/lib/libfst.so
OPENFSTLDFLAGS = -Wl,-rpath=$(FSTROOT)/lib


DOUBLE_PRECISION = 0
CXXFLAGS = $(COMPILER_CXXFLAGS) -pthread -Wall -I.. \
      -DKALDI_DOUBLEPRECISION=$(DOUBLE_PRECISION) \
      -Wall -Wno-sign-compare -Wno-unused-local-typedefs \
      -Wno-deprecated-declarations -Winit-self \
      -DHAVE_EXECINFO_H=1 -DHAVE_CXXABI_H \
      $(CXXFLAGS_MATH) \
      -I$(FSTROOT)/include \
      $(EXTRA_CXXFLAGS)

ifeq ($(KALDI_FLAVOR), dynamic)
CXXFLAGS += -fPIC
endif

LDFLAGS = $(OPENFSTLDFLAGS) -Wl,-rpath,$(EBROOTGCCCORE)/lib64 -rdynamic
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

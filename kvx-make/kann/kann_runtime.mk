#
# Copyright (C) 2021 Kalray SA. All rights reserved.
#

use-module += opencl-kernel

SRCDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
common_libs := -lmppa-kann-tensors -lmppa-kann-custom -lflatccrt

###############################################################################
#                             KaNN Runtime
###############################################################################

kann_opencl_kernel-name := mppa_kann_opencl.cl.pocl
kann_opencl_kernel-srcs := $(SRCDIR)/mppa_kann_opencl.cl
kann_opencl_kernel-deps :=
kann_opencl_kernel-clflags := -DENABLE_WG_SIZE
kann_opencl_kernel-cl-lflags := -lmppa-kann-rt $(common_libs)
opencl-kernel-bin += kann_opencl_kernel

###############################################################################
#                        KaNN Runtime with trace
###############################################################################

kann_opencl_kernel_trace-name := mppa_kann_opencl_trace.cl.pocl
kann_opencl_kernel_trace-srcs := $(kann_opencl_kernel-srcs)
# Fix: Depends on kann_opencl_kernel to prevent parallel build and
# pocl cache collision because of using the same sources.
kann_opencl_kernel_trace-deps := $(kann_opencl_kernel-deps) kann_opencl_kernel
kann_opencl_kernel_trace-clflags := $(kann_opencl_kernel-clflags)
kann_opencl_kernel_trace-cl-lflags := -lmppa-kann-rt-trace $(common_libs) \
                                      -Wl,--version-script=$(SRCDIR)/exp.ld
opencl-kernel-bin += kann_opencl_kernel_trace

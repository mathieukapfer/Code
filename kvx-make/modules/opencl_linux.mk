######################################
# Copyright (C) 2008-2020 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(opencl_linux_included),)

opencl_linux_included := 1

__common_linux_opencl_lflags = -lOpenCL -lmppa_offload_host -lmopd -lmppa_rproc_host -lpthread -lm

__common_linux_opencl_cflags += -Wno-deprecated-declarations
__common_linux_opencl_cppflags += $(__host_linux_opencl_cflags)

#
# Add Linux OpenCL flags
# $(1): Target name
#
define add_opencl_linux_host_flags

$(1)-lflags += $(__common_linux_opencl_lflags)
$(1)-cflags += $(__common_linux_opencl_cflags)
$(1)-cppflags += $(__common_linux_opencl_cppflags)

endef

$(foreach _a,$(host-bin),\
	$(eval $(call add_opencl_linux_host_flags,$(_a))) \
)

#
# Add KVX Linux OpenCL flags
# $(1): Target name
#
define add_opencl_linux_cluster_flags

$(1)-lflags += $(__common_linux_opencl_lflags)
$(1)-cflags += $(__common_linux_opencl_cflags)
$(1)-cppflags += $(__common_linux_opencl_cppflags)

endef

$(foreach _a,$(cluster-bin),$(if $(filter $($(_a)-system),linux), \
	$(eval $(call add_opencl_linux_cluster_flags,$(_a))), \
))

ifeq ($(cluster-system),linux)
$(foreach _a,$(cluster-bin),$(if $(filter $($(_a)-system),cos), \
	,$(eval $(call add_opencl_linux_cluster_flags,$(_a))) \
))
endif

endif

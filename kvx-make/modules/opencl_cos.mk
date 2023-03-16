######################################
# Copyright (C) 2008-2020 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(opencl_cos_included),)

opencl_cos_included := 1
opencl_cos_lib_fw_dir :=
_accelerator_incbin := _accelerator_incbin_kv3_1

ifeq ($(arch),kv3-2)
opencl_cos_lib_fw_dir := kv3-2/
_accelerator_incbin := _accelerator_incbin_kv3_2
endif

KALRAY_OPENCL_ACCELERATOR_PATH ?= $(KALRAY_TOOLCHAIN_DIR)/share/pocl/cos_standalone
ifeq ($(strip $(POCL_MPPA_AUTOTRACE_ENABLE)),1)
  POCL_MPPA_FIRMWARE_NAME ?= ocl_fw_autotrace.elf
  $(info Info: POCL_MPPA_AUTOTRACE_ENABLE is enabled, using $(POCL_MPPA_FIRMWARE_NAME))
else ifeq ($(strip $(POCL_MPPA_TRACE_ENABLE)),1)
  POCL_MPPA_FIRMWARE_NAME ?= ocl_fw_trace.elf
  $(info Info: POCL_MPPA_TRACE_ENABLE is enabled, using $(POCL_MPPA_FIRMWARE_NAME))
else
  POCL_MPPA_FIRMWARE_NAME ?= ocl_fw.elf
endif

__host_cos_opencl_lflags = -L$(KALRAY_TOOLCHAIN_DIR)/kvx-cos/lib/$(opencl_cos_lib_fw_dir)static -lOpenCL -lmppa_offload_host -lmppa_rproc_host
__host_cos_opencl_lflags += -Tmppadcos_ddr.ld
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_MASTER_CC=0
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_NB_CC=1
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_NB_CORES_LOG2=4
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_THREAD_PER_CORE_LOG2=0
__host_cos_opencl_lflags += -lrproc -lopen_amp -lmetal -Wl,--defsym=USER_STACK_SIZE=0x8000
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_ENABLE_HOST=1
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_DDR_SIZE=0x020000000
__host_cos_opencl_lflags += -Wl,--defsym=MPPA_COS_DDR_CACHED_SIZE=0x020000000
#__host_cos_opencl_lflags += -lmppal2_1m -Wl,--defsym=MPPA_COS_LOCALMEM_SIZE=3M  -u mppa_l2_init -Wl,--defsym=MPPA_COS_ENABLE_L2_CACHE=1

__host_cos_opencl_cflags += -Wno-deprecated-declarations
__host_cos_opencl_cppflags += $(__host_cos_opencl_cflags)

#
# Add cos OpenCL flags and srcs
# $(1): Target name
#
define add_opencl_cos_cluster_flags

$(1)-srcs += $(KALRAY_OPENCL_ACCELERATOR_PATH)/$(opencl_cos_lib_fw_dir)fw_incbin.c
$(1)-bins += $(_accelerator_incbin)
$(1)-lflags += $(__host_cos_opencl_lflags)
$(1)-cflags += $(__host_cos_opencl_cflags) -DPOCL_MPPA_FIRMWARE_NAME=\"$(POCL_MPPA_FIRMWARE_NAME)\"
$(1)-cppflags += $(__host_cos_opencl_cppflags)

endef

$(foreach _a,$(cluster-bin),$(if $(filter $($(_a)-system),cos), \
	$(eval $(call add_opencl_cos_cluster_flags,$(_a))), \
))


ifeq ($(cluster-system),cos)
$(foreach _a,$(cluster-bin),$(if $(filter $($(_a)-system),linux), \
	,$(eval $(call add_opencl_cos_cluster_flags,$(_a))) \
))
endif

KALRAY_OPENCL_ACCELERATOR_FULL_PATH := $(KALRAY_OPENCL_ACCELERATOR_PATH)/$(opencl_cos_lib_fw_dir)$(POCL_MPPA_FIRMWARE_NAME)
$(_accelerator_incbin)-binary := $(KALRAY_OPENCL_ACCELERATOR_FULL_PATH)
$(_accelerator_incbin)-align := 64
$(_accelerator_incbin)-section := .rodata

included-bin += $(_accelerator_incbin)

include $(__module_str)/incbin.mk

endif

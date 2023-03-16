# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(opencl_kernel_included),)

opencl_kernel_included := 1

__all_opencl_kernels =

POCLPP_FLAGS = -cl-std=CL1.2 \
		-D__OPENCL_VERSION__=__OPENCL_C_VERSION__ \
		-D__ENDIAN_LITTLE__=1 \
		-D__EMBEDDED_PROFILE__=1
PP_FLAGS := $(POCLPP_FLAGS) -nostdinc -E -undef -x assembler-with-cpp

KVX_POCLCC ?= $(KALRAY_TOOLCHAIN_DIR)/bin/kvx-poclcc
opencl-kernel-cache-dir ?= $(KERNEL_DIR)/kcache
KVX_POCLCC_ARCH ?= $(arch)

#
# Rules to generate a kernelbinary using kvx-poclcc
# This rules also extract dependencies automatically using clang with
# preprocessing only
#
quiet_cmd_gen-kernel = KVX_POCLCC\t$@
      cmd_gen-kernel = LD_LIBRARY_PATH=$(KALRAY_TOOLCHAIN_DIR)/lib \
			PATH=$(KALRAY_TOOLCHAIN_DIR)/bin:$$PATH \
			POCL_MPPA_EXTRA_BUILD_ARCH="$(KVX_POCLCC_ARCH)" \
			POCL_MPPA_EXTRA_BUILD_LFLAGS="$(3) $($(2)_cl_lflags)" \
			POCL_CACHE_DIR=$($(2)-cache-dir) \
			$(poclcc-env) $($(2)-poclcc-env) \
			POCL_EXTRA_BUILD_FLAGS="$($(2)_cl_flags)" \
			$(if $(strip $(V)),POCL_DEBUG=1,) \
			$(KVX_POCLCC) $(poclcc-opts) $($(2)-poclcc-opts) -o $@ $($(2)_cl_file) \
			$(if $(strip $(Q)),> /dev/null,) \
			$(if $($(2)-no-auto-dep),,;$(KVX_CLANG) $(depgencmd) $($(2)_cl_flags) $(PP_FLAGS) -o /dev/null $($(2)_cl_file))

#####################################################
# Generates flags for kernel library
# $(1) = target name
# $(2) = flags type (cflags cppflags lflags)
#####################################################
define gen_kernel_lib_flags
$(1)_kernel_lib-$(2) = -fPIC $(opencl-kernel-$(2)) $($(1)-$(2))
endef

#####################################################
# Generates base variables for kernel generation
# $(1) = target name
#####################################################
define kernel_var
$(if $($(1)-srcs),,$(error $(1)-srcs must be defined to generate kernel))

$(1)-name ?= $(1).bin
$(1)-cache-dir ?= $(opencl-kernel-cache-dir)/$(1)
$(1)_cl_file = $(filter %.cl,$($(1)-srcs))

$(1)_cl_flags = $(opencl-kernel-clflags) $($(1)-clflags)
$(1)_cl_lflags = -L$(LIB_OUTPUT_DIR)/cluster/ $(opencl-kernel-cl-lflags) $($(1)-cl-lflags)

$(1)_kernel_lib-srcs = $(filter-out %.cl,$($(1)-srcs))
$(1)_kernel_lib-type = static
$(1)_kernel_lib-system = cos

$(1)_kernel_lib_file = $$(if $$($(1)_kernel_lib-srcs),$(LIB_OUTPUT_DIR)/cluster/lib$(1)_kernel_lib.a,)

$(foreach _f,cflags cppflags lflags,\
	$(eval $(call gen_kernel_lib_flags,$(1),$(_f)))\
)
endef

#####################################################
# Generates kernel
# $(1) = target name
#####################################################
define kernel_gen_rule

$(if $($(1)_cl_file),,$(error $(1)-srcs must contain one .cl file))

# Add the lib if there is at least some -srcs
# We do it now to avoid deferred expansion in kernel_var
cluster-lib += $(if $($(1)_kernel_lib-srcs),$(1)_kernel_lib,)

$(KERNEL_DIR)/$($(1)-name): $($(1)_cl_file) $($(1)-srcs) $($(1)_kernel_lib_file)
$(KERNEL_DIR)/$($(1)-name): $($(1)-deps) $($(1)-link-deps) $(KERNEL_DIR)/$(dir $($(1)-name))/.dirstamp FORCE
	$$(call build_if_changed,gen-kernel,$(1),$($(1)_kernel_lib_file))

PHONY += $(1)
$(1): $(KERNEL_DIR)/$($(1)-name) FORCE

$(1)_final_file = $(KERNEL_DIR)/$($(1)-name)

module_obj_hooks += $(KERNEL_DIR)/$($(1)-name)
module_main_hooks += $(1)

__all_opencl_kernels += $(1)

endef

$(foreach _k,$(opencl-kernel-bin),\
	$(eval $(call kernel_var,$(_k)))\
	$(eval $(call kernel_gen_rule,$(_k)))\
)

module_clean_files += $(KERNEL_DIR)

endif
